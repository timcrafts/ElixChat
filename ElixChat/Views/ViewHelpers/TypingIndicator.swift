//
//  TypingIndicator.swift
//  ElixChat
//
//  Created by Tim on 24/12/2025.
//

import SwiftUI


struct TypingIndicator: View {
    @State private var phase = 0.0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(.secondary)
                    .frame(width: 6, height: 6)
                    .opacity(0.5)
                    .scaleEffect(phase == Double(index) ? 1.2 : 0.8)
                    .animation(.easeInOut(duration: 0.6).repeatForever().delay(Double(index) * 0.2), value: phase)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: Capsule())
        .onAppear { phase = 3.0 }
    }
}
