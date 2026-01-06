//
//  SessionManager.swift
//  ElixChat
//
//  Created by Tim on 06/01/2026.
//

import Foundation
import SwiftUI

final class SessionManager {
    var sessions: [ChatSession] = []
    var currentSessionId: UUID?
    
    init() {
        currentSessionId = nil
        loadSessions()
        createSession()
    }
    
    func createSession() {
        let session = ChatSession.newSession()
        sessions.append(session)
        currentSessionId = session.id
    }
    
    func loadSessions() {
        
    }
    
    func saveSession() {
        
    }
    
    func deleteSession(_ id: UUID) {
        sessions.removeAll { $0.id == id }
        if let lastID = sessions.last?.id {
            currentSessionId = lastID
        } else {
            createSession()
        }
    }
    
    func getSelectedSession() -> Binding<ChatSession>? {
        guard let selectedId = currentSessionId,
              let index = sessions.firstIndex(where: { $0.id == selectedId }) else {
            return nil
        }
        
        return Binding(
            get: { self.sessions[index] },
            set: { self.sessions[index] = $0 }
        )
    }
}

