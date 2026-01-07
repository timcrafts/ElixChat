//
//  LLMModels.swift
//  ElixChat
//
//  Created by Tim on 23/12/2025.
//

import Foundation
import EneyLocal
import MnemosSDK
import LanguageModels

protocol LLMServiceProtocol: Sendable {
    var isReady: Bool { get async }
    func initializeEngine(with configuration: EngineConfiguration, completion: @escaping (Progress) -> Void) async throws
    func sendMessage(_ text: String, conversationId: UUID) async throws -> String
    func isEngineReady() -> Bool
}

actor LLMService: LLMServiceProtocol {
    
    private var engine: LocalEngine?
    private var mnemos: Mnemos?
    private var languageModelsFactory: LanguageModelsFactory?
    
    var isReady: Bool = false
    
    init() {}
    
    func initializeEngine(with configuration: EngineConfiguration, completion: @escaping (Progress) -> Void) async throws {
        // --- KEY FIX: Set Environment Variable ---
        // Some underlying libraries ignore the config object and look strictly for the env var.
        if !configuration.hfToken.isEmpty {
            setenv("HF_TOKEN", configuration.hfToken, 1)
        }
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let modelsURL: URL
        if configuration.modelPath.hasPrefix("~") {
            modelsURL = documentsURL.appending(path: "EneyModels")
        } else {
            modelsURL = URL(filePath: configuration.modelPath)
        }
        
        let memoryURL = documentsURL.appending(path: "EneyMemory")
        
        try? fileManager.createDirectory(at: modelsURL, withIntermediateDirectories: true)
        try? fileManager.createDirectory(at: memoryURL, withIntermediateDirectories: true)
        
        print("Initializing EneyLocal...")
        
        // Initialize Factory
        let factory = LanguageModelsFactory(downloadBase: modelsURL)
        self.languageModelsFactory = factory
        
        // Initialize Mnemos
        let mnemos = try Mnemos(configuration: Mnemos.Configuration(filesRootURL: modelsURL, storeURL: memoryURL))
        self.mnemos = mnemos
        
        // Initialize Engine
        let engineConfig = LocalEngine.Configuration(hfToken: configuration.hfToken)
        
        let engine = LocalEngine(
            configuration: engineConfig,
            languageModels: factory,
            mnemos: mnemos,
            logger: EneyLocal.SwiftPrintLogger(verbosityLevel: .debug)
        )
        self.engine = engine
        
        // Load components
        try await mnemos.load { progress in
            print(progress)
            completion(progress)
        }
        try await engine.load()
        try await engine.update(tools: [])
        
        print("EneyLocal Engine is ready!")
        self.isReady = true
    }
    
    func sendMessage(_ text: String, conversationId: UUID) async throws -> String {
        guard let engine = self.engine, isReady else {
            throw NSError(domain: "EneyLocal", code: 1, userInfo: [NSLocalizedDescriptionKey: "Engine not initialized"])
        }
        
        let session = try await engine.retrieveSession(withId: conversationId)
        
        let messageId = UUID()
        let inputContent = Input.Content.inputMessage(
            Input.InputMessage(text: text, attachments: [])
        )
        
        let input = Input(id: messageId, content: inputContent)
        let response = try await session.createResponse(input: input)
        
        switch response.output {
        case .textMessage(let responseText):
            return responseText
        case .toolCall(let toolCall):
            return "[System: Model executed tool '\(toolCall.name)']"
        }
    }
    
    func offloadModel() async {
        await languageModelsFactory?.resetCache()
    }
    
    func isEngineReady() -> Bool {
        let result = isReady
        return result
    }
}
