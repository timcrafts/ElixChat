//
//  MessageBubble.swift
//  ElixChat
//
//  Created by Tim on 24/12/2025.
//
import Foundation
import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if message.role == .user {
                Spacer()
            } else {
                Image("eney")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.leading, 10)
            }
            
            VStack(alignment: .leading) {
                Text(message.content)
                    .font(.system(.body, design: .rounded))
                    .lineSpacing(4)
                    .padding(10)
                    .glassEffect(.clear.tint(
                        message.role == .user ?
                        Color.gray.opacity(0.15) : // Tint for user
                        Color(red: 1, green: 0.2, blue: 0.7).opacity(0.4)
                    ), in: RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .textSelection(.enabled)
            }
            .frame(maxWidth: 600, alignment: message.role == .user ? .trailing : .leading)
            .padding(.horizontal, 10)
            if message.role == .user {
                // Avatar for user could go here
            } else {
                Spacer()
            }
        }
    }
}

#Preview {
    VStack{
        MessageBubble(message: ChatMessage(role: .assistant, content: "How are you"))
        MessageBubble(message: ChatMessage(role: .user, content: "How are you"))
        MessageBubble(message: ChatMessage(role: .assistant, content: "I'm ok\nThanks!"))
    }
    .padding(.vertical, 20)
}
