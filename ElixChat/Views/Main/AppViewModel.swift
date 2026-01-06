//
//  ViewModels.swift
//  ElixChat
//
//  Created by Tim on 23/12/2025.
//

import Foundation
import Observation
import SwiftUI

import Foundation
import Observation
import SwiftUI
import EneyLocalDebug

@MainActor
@Observable
class AppViewModel {
    var engineConfig = EngineConfiguration()
    var isEngineLoading = false
    var isEngineReady: Bool { llmService.isEngineReady() }
    var engineError: Error?
    var currentSession: ChatSession?
    
    let llmService: any LLMServiceProtocol
    let engineConfigurationProvider: ConfigurationProvider = .init()
    let sessionManager: SessionManager = .init()
    
    init(service: any LLMServiceProtocol) {
        // Conform to Example: Initialize debug logging/tools early
        EneyLocalDebug.initialize()
        llmService = service
        loadSettings()
        
        sessionManager.createSession()
        currentSession = sessionManager.sessions.last
    }
    
    //MARK: - Engine Configuration
    
    private func loadSettings() {
        let result = engineConfigurationProvider.getConfiguration()
        
        engineError = result.1
        engineConfig = result.0
    }

    private func saveSettings() {
        engineConfigurationProvider.setConfiguration(engineConfig)
    }
    
    func initializeEngine() async {
        isEngineLoading = true
        
        // Reload settings to ensure we have the latest token from Keychain
        loadSettings()
        
        if let configError = engineError as? EngineConfigurationError, configError == .tokenMissing {
            isEngineLoading = false
            return
        }
        
        // Conform to Example: The example relies on the "HF_TOKEN" environment variable being set.
        // EneyLocal (and underlying Python/C++ libs) look for this variable directly.
        if !engineConfig.hfToken.isEmpty {
            setenv("HF_TOKEN", engineConfig.hfToken, 1)
        }
        
        do {
            try await llmService.initializeEngine(with: engineConfig)
            isEngineLoading = false
            engineError = nil
        } catch {
            isEngineLoading = false
            engineError = error
        }
    }
    
    func retryInitialization() async {
        engineError = nil
        await initializeEngine()
    }
    
    func updateToken(_ token: String) async {
//        let cleanToken = token.trimmingCharacters(in: .whitespacesAndNewlines)
        
        engineConfigurationProvider.updateToken(token)
        
        // Refresh settings immediately
        loadSettings()
        
        // Set env var immediately for the retry
//        setenv("HF_TOKEN", cleanToken, 1)
        
        await initializeEngine()
    }
    
    //MARK: - Chat & Sessions
    func createNewChat() {
        sessionManager.createSession()
        currentSession = sessionManager.sessions.last
    }
    
    func deleteSession(id: UUID) {
        sessionManager.deleteSession(id)
    }
}
