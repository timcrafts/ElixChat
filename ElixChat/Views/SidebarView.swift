//
//  SidebarView.swift
//  ElixChat
//
//  Created by Tim on 24/12/2025.
//

import SwiftUI
import Foundation
import SwiftUI

//struct SidebarView: View {
//    // В Observation фреймворку не потрібні обгортки, якщо ми просто читаємо дані
//    var viewModel: AppViewModel
//    @Binding var showSettings: Bool
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // Header
//            HStack {
//                Text("Chats")
//                    .font(.system(size: 16, weight: .semibold, design: .rounded))
//                    .foregroundColor(.secondary)
//                Spacer()
//            }
//            .padding(.horizontal)
//            .padding(.top, 20)
//            .padding(.bottom, 10)
//            
//            // New Chat Button
//            Button(action: {
//                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
//                    viewModel.createNewChat()
//                }
//            }) {
//                HStack {
//                    Image(systemName: "plus.circle.fill")
//                        .font(.title2)
//                        .symbolRenderingMode(.hierarchical)
//                    Text("Новий чат")
//                        .font(.headline)
//                    Spacer()
//                }
//                .padding()
//                .background(Color.accentColor.opacity(0.15))
//                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
//                )
//            }
//            .buttonStyle(.plain)
//            .padding(.horizontal)
//            .padding(.bottom, 20)
//            
//            // Session List
//            ScrollView {
//                LazyVStack(spacing: 8) {
//                    ForEach(viewModel.sessions) { session in
//                        SessionRowView(session: session, isSelected: viewModel.selectedSessionId == session.id) {
//                            viewModel.selectedSessionId = session.id
//                        }
//                        .contextMenu {
//                            Button("Видалити", role: .destructive) {
//                                viewModel.deleteSession(id: session.id)
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal)
//            }
//            
//            Spacer()
//            
//            // Settings Button
//            Button(action: { showSettings = true }) {
//                HStack {
//                    Image(systemName: "gearshape")
//                    Text("Налаштування")
//                }
//                .padding(12)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .contentShape(Rectangle())
//            }
//            .buttonStyle(.plain)
//            .padding()
//        }
//    }
//}
