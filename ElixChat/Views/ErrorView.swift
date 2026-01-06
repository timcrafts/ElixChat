//
//  ErrorView.swift
//  ElixChat
//
//  Created by Tim on 06/01/2026.
//

import SwiftUI

struct ErrorView: View {
    var viewModel: AppViewModel
    @State private var tokenInput: String = ""
    @State private var isUpdating: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            if isTokenError {
                tokenMissingContent
            } else {
                genericErrorContent
            }
        }
        .padding(32)
        .frame(maxWidth: 420)
        .liquidGlass(material: .regular)
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
    }
    
    // MARK: - Helpers
    
    private var isTokenError: Bool {
        if let error = viewModel.engineError as? EngineConfigurationError {
            return error == .tokenMissing
        }
        return false
    }
    
    // MARK: - Token Missing UI
    
    private var tokenMissingContent: some View {
        VStack(spacing: 16) {
            Image(systemName: "key.fill")
                .font(.system(size: 48))
                .foregroundStyle(.linearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                .symbolEffect(.pulse, options: .repeating)
            
            Text("Authentication Required")
                .font(.title2.bold())
            
            Text("To use the Eney engine, you need to provide a Hugging Face access token.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Hugging Face Token")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 4)
                
                SecureField("hf_...", text: $tokenInput)
                    .textFieldStyle(.plain)
                    .frame(minWidth: 100)
                    .padding(12)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.secondary.opacity(0.2), lineWidth: 1))
            }
            .padding(.top, 8)
            
            Button(action: saveToken) {
                HStack {
                    if isUpdating {
                        ProgressView().controlSize(.small)
                            .padding(.trailing, 4)
                    }
                    Text("Save & Connect")
                }
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .cornerRadius(12)
                .shadow(color: .accentColor.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(.plain)
            .disabled(tokenInput.isEmpty || isUpdating)
            .padding(.top, 8)
        }
    }
    
    // MARK: - Generic Error UI
    
    private var genericErrorContent: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.yellow)
            
            Text("Initialization Failed")
                .font(.title2.bold())
            
            Text(viewModel.engineError?.localizedDescription ?? "An unknown error occurred.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            Button(action: retry) {
                Label("Retry Initialization", systemImage: "arrow.clockwise")
                    .fontWeight(.medium)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(.secondary.opacity(0.2), lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Actions
    
    private func saveToken() {
        guard !tokenInput.isEmpty else { return }
        isUpdating = true
        Task {
            await viewModel.updateToken(tokenInput)
            isUpdating = false
        }
    }
    
    private func retry() {
        Task {
            await viewModel.retryInitialization()
        }
    }
}

#Preview {
    ErrorView(viewModel: AppViewModel.init(service: LLMService()))
}
