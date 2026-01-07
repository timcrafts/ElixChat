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
    @State var isHovering: Bool = false
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if message.role == .user {
                Spacer()
                copyButton()
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
            .padding(message.role == .user ? .trailing : .leading, 10)
            .padding(message.role == .user ? .leading : .trailing, !isHovering ? 20 : 0)
            if message.role == .user {
                // Avatar for user could go here
            } else {
                copyButton()
                Spacer()
            }
        }
        .onHover{ status in
            withAnimation {
                isHovering = status
            }
        }
    }
    
    @ViewBuilder
    func copyButton() -> some View {
        if isHovering {
            Button{
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(message.content, forType: .string)
            } label: {
                Image(systemName: "document")
                    .foregroundStyle(.secondary)
                    .padding(5)
            }
            .buttonStyle(.plain)
        } else {
            EmptyView()
        }
    }
    
    private func copyAction() {
        
    }
}

#Preview {
    VStack{
        MessageBubble(message: ChatMessage(role: .assistant, content: "How are you"))
        MessageBubble(message: ChatMessage(role: .user, content: "How are youHow are youHow are youHow are youHow are youHow are youHow are youHow are youHow are you"))
        MessageBubble(message: ChatMessage(role: .assistant, content: "I'm ok\nThanks!"))
    }
    .padding(.vertical, 20)
}
