//
//  ChatView.swift
//  ElixChat
//
//  Created by Tim on 24/12/2025.
//

import SwiftUI
import Observation

struct ChatView: View {
    var viewModel: ChatViewModel
    @State private var inputMessage: String = ""
    @FocusState private var isInputFocused: Bool
    
    init(session: ChatSession, llmService: any LLMServiceProtocol) {
        viewModel = ChatViewModel(session: session, llmService: llmService)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            chatList
                .safeAreaInset(edge: .bottom, content: { inputBar })
        }
        .onAppear {
            isInputFocused = true
        }
    }

    
    private var chatList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 24) {
                    Spacer().frame(height: 20)
                    
                    ForEach(viewModel.session.messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    if viewModel.isTyping {
                        HStack {
                            TypingIndicator()
                                .scaleEffect(0.8)
                                .padding(.leading)
                            Spacer()
                        }
                        .id("typingIndicator")
                    }
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .padding(12)
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                            .padding()
                    }
                    
                    Spacer().frame(height: 80)
                }
                .padding(.horizontal)
            }
            .onChange(of: viewModel.session.messages.count) { _, _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: viewModel.isTyping) { _, newValue in
                if newValue { scrollToBottom(proxy: proxy, id: "typingIndicator") }
            }
        }
    }
    
    private var inputBar: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 6) {
                TextField("Ask anything...", text: $inputMessage, axis: .vertical)
                    .font(.system(.body, design: .rounded))
                    .textFieldStyle(.plain)
                    .focused($isInputFocused)
                    .frame(minHeight: 30)
                    .lineLimit(1...8)
                    .onSubmit { sendMessage() }
                    .padding(.leading, 6)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(
                            Circle()
                                .fill(LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .disabled(inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isTyping)
                .buttonStyle(.plain)
            }
            .padding(10)
            .glassEffect(in: ConcentricRectangle(corners: .concentric(minimum: 28)))
            .padding(10)
        }
    }
    
    private func sendMessage() {
        guard !inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        withAnimation {
            viewModel.sendMessage(inputMessage)
            inputMessage = ""
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy, id: AnyHashable? = nil) {
        withAnimation(.spring()) {
            if let id = id {
                proxy.scrollTo(id, anchor: .bottom)
            } else if let lastId = viewModel.session.messages.last?.id {
                proxy.scrollTo(lastId, anchor: .bottom)
            }
        }
    }
}

#Preview {
    @Previewable @State var mockSession =
    ChatSession(
        id: UUID(),
        title: "Test",
          messages: [
            ChatMessage(role: .user, content: "Hello"),
            ChatMessage(role: .assistant, content: "How are you"),
            ChatMessage(role: .user, content: "Hello"),
            ChatMessage(role: .assistant, content: "How are you"),
            ChatMessage(role: .user, content: "Hello"),
            ChatMessage(role: .assistant, content: "How are you")
          ],
          lastModified: Date.now
    )
    ChatView(session: mockSession , llmService: LLMService())
}
