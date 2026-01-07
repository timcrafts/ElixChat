//
//  ElixChatTests.swift
//  ElixChatTests
//
//  Created by Tim on 23/12/2025.
//

import Testing
import Foundation
import SwiftUI
@testable import ElixChat

// --- MOCK SERVICE ---

actor MockLLMService: LLMServiceProtocol {
    var isReady: Bool = false
    var shouldFail: Bool = false
    
    func initializeEngine(with configuration: EngineConfiguration) async throws {
        if shouldFail {
            throw NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock Init Failed"])
        }
        isReady = true
    }
    
    func sendMessage(_ text: String, conversationId: UUID) async throws -> String {
        if !isReady {
            throw NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Engine not initialized"])
        }
        return "Mock Response to: \(text)"
    }
    
    func isEngineReady() -> Bool {
        return isReady
    }
}

// --- TEST SUITES ---

@Suite("App Logic Tests")
struct AppViewModelTests {
    
    @Test("Ініціалізація двигуна (Успіх)")
    @MainActor
    func testEngineInitSuccess() async {
        // Arrange
        let mockService = MockLLMService()
        let viewModel = AppViewModel(service: mockService)
        // Simulate a valid config being present
        viewModel.engineConfig.hfToken = "valid_token"
        
        // Act
        await viewModel.initializeEngine()
        
        // Assert
        let isReady = await mockService.isReady
        #expect(isReady == true, "Сервіс має бути готовий")
        #expect(viewModel.engineError == nil, "Помилок не має бути")
        #expect(viewModel.isEngineLoading == false, "Має припинити завантаження")
    }
    
    @Test("Ініціалізація двигуна (Помилка - немає токена)")
    @MainActor
    func testEngineInitMissingToken() async {
        let mockService = MockLLMService()
        let viewModel = AppViewModel(service: mockService)
        // Ensure token is empty
        viewModel.engineConfig.hfToken = ""
        
        await viewModel.initializeEngine()
        
        // Assert
        #expect(viewModel.engineError != nil, "Має з'явитись помилка про відсутність токена")
        if let error = viewModel.engineError as? EngineConfigurationError {
            #expect(error == .tokenMissing)
        }
        let isReady = await mockService.isReady
        #expect(isReady == false, "Сервіс не має ініціалізуватись")
    }
}

@Suite("Chat Interaction Tests")
struct ChatViewModelTests {
    
    @Test("Відправка повідомлення (Happy Path)")
    @MainActor
    func testSendMessage() async throws {
        // Arrange
        let mockService = MockLLMService()
        // Initialize mock manually
        let config = EngineConfiguration(hfToken: "test")
        try await mockService.initializeEngine(with: config)
        
        // Single session from AppViewModel
        let appViewModel = AppViewModel(service: mockService)
        // Manually fix the session dependency for the test
        let viewModel = ChatViewModel(session: appViewModel.currentSession, llmService: mockService)
        
        // Act
        let input = "Привіт, світе!"
        viewModel.sendMessage(input)
        
        // Assert Immediate State (User message added)
        #expect(appViewModel.currentSession.messages.count == 1, "Повідомлення користувача має додатись одразу")
        #expect(appViewModel.currentSession.messages.first?.role == .user)
        #expect(viewModel.isTyping == true, "Індикатор набору має бути активним")
        
        // Wait for Async Response
        try await Task.sleep(nanoseconds: 200_000_000)
        
        // Assert Final State (AI Response added)
        #expect(appViewModel.currentSession.messages.count == 2, "Має бути 2 повідомлення (User + AI)")
        #expect(appViewModel.currentSession.messages.last?.role == .assistant)
        #expect(appViewModel.currentSession.messages.last?.content.contains("Mock Response") == true)
        #expect(viewModel.isTyping == false, "Індикатор набору має зникнути")
    }
}
