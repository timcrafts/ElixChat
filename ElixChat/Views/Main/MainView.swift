//
//  MainView.swift
//  ElixChat
//
//  Created by Tim on 24/12/2025.
//

import SwiftUI

struct MainView: View {
    @Environment(AppViewModel.self) var appViewModel
    
    var body: some View {
        ZStack {
            // Ambient Background
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
            
            // Content State Machine
            if appViewModel.isEngineLoading {
                loadingView
            } else if appViewModel.engineError != nil {
                ErrorView(viewModel: appViewModel)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else {
                if let currentSession = appViewModel.currentSession {
                    // Direct access to the single chat session
                    ChatView(
                        session: currentSession,
                        llmService: appViewModel.llmService
                    )
                    .transition(.opacity)
                } else {
                    EmptyView()
                }

            }
        }
        .animation(.easeInOut(duration: 0.3), value: appViewModel.isEngineLoading)
        .animation(.easeInOut(duration: 0.3), value: appViewModel.engineError != nil)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.extraLarge)
            Text("Initializing Engine...")
                .font(.headline)
                .foregroundStyle(.secondary)
            if let progress = appViewModel.loadingProgress {
                ProgressView(progress)
                    .frame(maxWidth: 200)
            }
            
        }
        .padding(40)
        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 20))
    }
}
