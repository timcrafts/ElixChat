//
//  ElixChatApp.swift
//  ElixChat
//
//  Created by Tim on 23/12/2025.
//

import SwiftUI

@main
struct ElixChatApp: App {
    private var appViewModel: AppViewModel
    
    init() {
        let service = LLMService()
        appViewModel = AppViewModel(service: service)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(appViewModel)
                .background(WindowAccessor { window in
                    window.isOpaque = false
                    window.backgroundColor = .black.withAlphaComponent(0.95)
                    window.titlebarAppearsTransparent = true
                    window.titleVisibility = .hidden
                    window.styleMask.insert(.fullSizeContentView)
                    
                    // Allow moving the window by dragging the background
                    window.isMovableByWindowBackground = true
                })
        }
        // Hide the standard system title bar
        .windowStyle(.hiddenTitleBar)
        // Set a default size (optional but good for custom windows)
        .defaultSize(width: 450, height: 600)
    }
}

// Helper to access the underlying NSWindow
struct WindowAccessor: NSViewRepresentable {
    var callback: (NSWindow) -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                self.callback(window)
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
