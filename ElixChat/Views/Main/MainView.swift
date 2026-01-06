//
//  MainView.swift
//  ElixChat
//
//  Created by Tim on 24/12/2025.
//

import SwiftUI


struct MainView: View {
    // Отримуємо ViewModel з Environment
    @Environment(AppViewModel.self) var appViewModel
    @State private var showSettings = false
    
    var body: some View {
        NavigationSplitView {
//            SidebarView(viewModel: appViewModel, showSettings: $showSettings)
//                .navigationSplitViewColumnWidth(min: 220, ideal: 250)
//                .background(EffectView(material: .sidebar, blendingMode: .behindWindow))
            Text("empty")
        } detail: {
            ZStack {
                MeshGradientBackground()
                    .ignoresSafeArea()
                    .opacity(0.3)
                    .onAppear {
                        if !appViewModel.isEngineReady && !appViewModel.isEngineLoading {
                            Task {
                                await appViewModel.initializeEngine()
                            }
                        }
                    }
                
                // State Machine for Main Content
                if appViewModel.isEngineLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .controlSize(.extraLarge)
                        Text("Initializing Engine...")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(40)
                    .liquidGlass(material: .ultraThin)
                    
                } else if appViewModel.engineError != nil {
                    ErrorView(viewModel: appViewModel)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    
                } else {
                    // Success State
                    if let currentSession = appViewModel.currentSession {
                        ChatView(
                            session: currentSession,
                            llmService: appViewModel.llmService
                        )
                    } else {
                        EmptyStateView()
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: appViewModel.isEngineLoading)
            .animation(.easeInOut(duration: 0.3), value: appViewModel.engineError != nil)
        }
//        .sheet(isPresented: $showSettings) {
//            SettingsView(viewModel: appViewModel)
//        }
    }
}
