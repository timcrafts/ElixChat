//
//  ElixChatTests.swift
//  ElixChatTests
//
//  Created by Tim on 23/12/2025.
//

import Testing
import Foundation
import SwiftUI
@testable import EneyChat // Замініть на реальну назву вашого модуля

// --- MOCK SERVICE ---

actor MockLLMService: LLMServiceProtocol {
    var isReady: Bool = false
    var shouldFail: Bool = false
    var lastConfig: EngineConfiguration?
    
    func initializeEngine(hfToken: String, downloadPath: String) async throws {
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
    
    func updateSettings(config: EngineConfiguration) async {
        self.lastConfig = config
    }
}

// --- TEST SUITES ---

@Suite("App Logic Tests")
struct AppViewModelTests {
    
    @Test("Створення нового чату")
    @MainActor
    func testCreateNewChat() async {
        // Arrange
        let mockService = MockLLMService()
        let viewModel = AppViewModel(service: mockService)
        let initialCount = viewModel.sessions.count
        
        // Act
        viewModel.createNewChat()
        
        // Assert
        #expect(viewModel.sessions.count == initialCount + 1, "Кількість сесій має збільшитись на 1")
        #expect(viewModel.selectedSessionId == viewModel.sessions.first?.id, "Нова сесія має бути вибрана")
        #expect(viewModel.sessions.first?.title == "Новий чат", "Заголовок за замовчуванням має бути правильним")
    }
    
    @Test("Видалення чату")
    @MainActor
    func testDeleteChat() async {
        // Arrange
        let mockService = MockLLMService()
        let viewModel = AppViewModel(service: mockService)
        // Створюємо ще одну сесію, щоб було що видаляти (загалом буде 2)
        viewModel.createNewChat()
        let sessionToDelete = viewModel.sessions.first!
        
        // Act
        viewModel.deleteSession(id: sessionToDelete.id)
        
        // Assert
        #expect(viewModel.sessions.count == 1, "Має залишитись одна сесія")
        #expect(!viewModel.sessions.contains(where: { $0.id == sessionToDelete.id }), "Видалена сесія не має існувати")
    }
    
    @Test("Ініціалізація двигуна (Успіх)")
    @MainActor
    func testEngineInitSuccess() async {
        // Arrange
        let mockService = MockLLMService()
        let viewModel = AppViewModel(service: mockService)
        viewModel.engineConfig.hfToken = "valid_token"
        
        // Act
        // Оскільки initializeEngine запускає Task, нам треба трохи почекати або перевірити стан сервісу
        viewModel.initializeEngine()
        
        // Чекаємо завершення асинхронної задачі
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        let isReady = await mockService.isReady
        #expect(isReady == true, "Сервіс має бути готовий")
        #expect(viewModel.engineError == nil, "Помилок не має бути")
    }
    
    @Test("Ініціалізація двигуна (Помилка - немає токена)")
    @MainActor
    func testEngineInitMissingToken() async {
        let mockService = MockLLMService()
        let viewModel = AppViewModel(service: mockService)
        viewModel.engineConfig.hfToken = "" // Пустий токен
        
        viewModel.initializeEngine()
        
        // Assert (Перевірка синхронна, бо guard спрацьовує одразу)
        #expect(viewModel.engineError != nil, "Має з'явитись помилка про відсутність токена")
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
        // Примусово робимо сервіс готовим
        try await mockService.initializeEngine(hfToken: "test", downloadPath: "")
        
        var session = ChatSession.newSession()
        // Створюємо Binding для ViewModel
        let sessionBinding = Binding(get: { session }, set: { session = $0 })
        
        let viewModel = ChatViewModel(session: sessionBinding, llmService: mockService)
        viewModel.inputMessage = "Привіт, світе!"
        
        // Act
        viewModel.sendMessage()
        
        // Assert Immediate State (User message added)
        #expect(viewModel.inputMessage.isEmpty, "Поле вводу має очиститись")
        #expect(session.messages.count == 1, "Повідомлення користувача має додатись одразу")
        #expect(session.messages.first?.role == .user)
        #expect(viewModel.isTyping == true, "Індикатор набору має бути активним")
        
        // Wait for Async Response
        try await Task.sleep(nanoseconds: 200_000_000)
        
        // Assert Final State (AI Response added)
        #expect(session.messages.count == 2, "Має бути 2 повідомлення (User + AI)")
        #expect(session.messages.last?.role == .assistant)
        #expect(session.messages.last?.content.contains("Mock Response") == true)
        #expect(viewModel.isTyping == false, "Індикатор набору має зникнути")
    }
    
    @Test("Відправка повідомлення (Помилка двигуна)")
    @MainActor
    func testSendMessageError() async throws {
        // Arrange
        let mockService = MockLLMService()
        // НЕ ініціалізуємо сервіс -> isReady = false
        
        var session = ChatSession.newSession()
        let sessionBinding = Binding(get: { session }, set: { session = $0 })
        
        let viewModel = ChatViewModel(session: sessionBinding, llmService: mockService)
        viewModel.inputMessage = "Fail me"
        
        // Act
        viewModel.sendMessage()
        
        // Wait for Async Response
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        #expect(viewModel.errorMessage != nil, "Має бути повідомлення про помилку")
        #expect(session.messages.count == 1, "Повідомлення асистента НЕ має додатись при помилці")
    }
}

@Suite("Settings Tests")
struct SettingsTests {
    
    @Test("Оновлення налаштувань")
    @MainActor
    func testUpdateSettings() async {
        // Arrange
        let mockService = MockLLMService()
        let viewModel = AppViewModel(service: mockService)
        
        // Act
        viewModel.engineConfig.temperature = 0.9
        viewModel.engineConfig.maxTokens = 2048
        viewModel.updateSettings()
        
        try await Task.sleep(nanoseconds: 50_000_000)
        
        // Assert
        let serviceConfig = await mockService.lastConfig
        #expect(serviceConfig?.temperature == 0.9, "Температура в сервісі має оновитись")
        #expect(serviceConfig?.maxTokens == 2048, "Токени в сервісі мають оновитись")
    }
}
