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
        HStack(alignment: .bottom, spacing: 12) {
            if message.role == .user {
                Spacer()
            } else {
                Image(systemName: "sparkle")
                    .foregroundStyle(.linearGradient(colors: [.indigo, .cyan], startPoint: .top, endPoint: .bottom))
                    .font(.title3)
                    .frame(width: 32, height: 32)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1))
            }
            
            VStack(alignment: .leading) {
                Text(message.content)
                    .font(.system(.body, design: .rounded))
                    .lineSpacing(4)
                    .padding(16)
                    .background(
                        message.role == .user ?
                        AnyShapeStyle(Material.thin) : // User bubble
                        AnyShapeStyle(Material.ultraThin) // Assistant bubble
                    )
                    .background(
                        message.role == .user ?
                        Color.blue.opacity(0.15) : // Tint for user
                        Color.clear
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(message.role == .user ? 0.3 : 0.5), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .textSelection(.enabled)
            }
            .frame(maxWidth: 600, alignment: message.role == .user ? .trailing : .leading)
            
            if message.role == .user {
                // Avatar for user could go here
            } else {
                Spacer()
            }
        }
    }
}
