//
//  ConfigurationProvider.swift
//  ElixChat
//
//  Created by Tim on 06/01/2026.
//

import Foundation
import Security

struct EngineConfiguration: Equatable, Sendable, Codable {
    var temperature: Double = 0.7
    var maxTokens: Int = 1024
    var hfToken: String = "" // Hugging Face Token
    var modelPath: String = "~/Documents/EneyModels"
    var autoInitialize: Bool = true
    
    /// Returns a copy of the configuration with the sensitive token removed.
    func sanitized() -> Self {
        var safeConfig = self
        safeConfig.hfToken = ""
        return safeConfig
    }
}

final class ConfigurationProvider {
    // Keys for storage
    private let configurationKey: String = "eney_engine_config"
    private let keychainService: String = "com.eney.engine"
    private let keychainAccount: String = "hugging_face_token"
    
    /// Retrieves the full configuration.
    func getConfiguration() -> (EngineConfiguration, EngineConfigurationError?) {
        var config: EngineConfiguration
        if let data = UserDefaults.standard.data(forKey: configurationKey),
           let decoded = try? JSONDecoder().decode(EngineConfiguration.self, from: data) {
            config = decoded
        } else {
            config = EngineConfiguration()
        }
        
        let error: EngineConfigurationError?
        if let token = loadTokenFromKeychain(), !token.isEmpty {
            config.hfToken = token
            error = nil
        } else {
            error = .tokenMissing
        }
        
        return (config, error)
    }
    
    /// Saves the configuration.
    func setConfiguration(_ engineConfig: EngineConfiguration) {
        if !engineConfig.hfToken.isEmpty {
            saveTokenToKeychain(token: engineConfig.hfToken)
        }
        
        let safeConfig = engineConfig.sanitized()
        if let encoded = try? JSONEncoder().encode(safeConfig) {
            UserDefaults.standard.set(encoded, forKey: configurationKey)
        }
    }
    
    func updateToken(_ newToken: String) {
        let token = newToken.trimmingCharacters(in: .whitespacesAndNewlines)

        saveTokenToKeychain(token: token)
        
        setenv("HF_TOKEN", token, 1)
    }
    
    // MARK: - Keychain Helpers
    
    private func saveTokenToKeychain(token: String) {
        let data = Data(token.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ]
        
        // 1. Delete any existing item first (Robust "Upsert")
        // This avoids issues where SecItemUpdate fails due to attribute mismatches
        SecItemDelete(query as CFDictionary)
        
        // 2. Add the new item
        var newQuery = query
        newQuery[kSecValueData as String] = data
        
        let status = SecItemAdd(newQuery as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error saving token to keychain: \(status)")
        }
    }
    
    private func loadTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
}

enum EngineConfigurationError: Error, LocalizedError {
    case noModelFileFound
    case tokenMissing
    
    var errorDescription: String? {
        switch self {
        case .noModelFileFound: return "Model file not found."
        case .tokenMissing: return "Hugging Face Access Token is missing."
        }
    }
}
