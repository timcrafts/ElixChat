//
//  ChatViewModel.swift
//  ElixChat
//
//  Created by Tim on 24/12/2025.
//
import SwiftUI
import Observation

@MainActor
@Observable
class ChatViewModel {
    var session: ChatSession
    
    // Збережені властивості (Stored properties)
    var isTyping: Bool = false
    var errorMessage: String?
    
    let llmService: any LLMServiceProtocol
    
    init(session: ChatSession, llmService: any LLMServiceProtocol) {
        self.session = session
        self.llmService = llmService
    }
    
    func sendMessage(_ inputMessage: String) {
        let text = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        // Додаємо повідомлення (User)
        let userMsg = ChatMessage(role: .user, content: text)
        session.messages.append(userMsg)
        
        // Очищаємо поле та оновлюємо дату
        session.lastModified = Date()
        
        // Оновлюємо заголовок, якщо це перше повідомлення
        if session.messages.count == 1 {
            session.title = String(text.prefix(30))
        }
        
        isTyping = true
        errorMessage = nil
        
        // Запит до LLM
        Task {
            do {
                let responseText = try await llmService.sendMessage(text, conversationId: session.id)
                let aiMsg = ChatMessage(role: .assistant, content: responseText)
                session.messages.append(aiMsg)
            } catch {
                errorMessage = error.localizedDescription
            }
            isTyping = false
        }
    }
}
