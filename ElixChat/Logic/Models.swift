//
//  Models.swift
//  ElixChat
//
//  Created by Tim on 23/12/2025.
//

import Foundation

// --- Models ---

enum MessageRole: String, Codable {
    case user
    case assistant
    case system
}

struct ChatMessage: Identifiable, Codable, Hashable {
    let id: UUID
    let role: MessageRole
    let content: String
    let timestamp: Date
    
    init(id: UUID = UUID(), role: MessageRole, content: String, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}

struct ChatSession: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var messages: [ChatMessage]
    var lastModified: Date
    
    static func newSession() -> ChatSession {
        ChatSession(id: UUID(), title: "Новий чат", messages: [], lastModified: Date())
    }
}

