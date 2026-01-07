//
//  TypingIndicator.swift
//  ElixChat
//
//  Created by Tim on 24/12/2025.
//

import SwiftUI


struct TypingIndicator: View {
    @State private var isOn = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(.white)
                    .frame(width: 6, height: 6)
                    .opacity(0.7)
                    .scaleEffect(isOn ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.15),
                        value: isOn
                    )
            }
        }
        .padding(12)
        .glassEffect(.clear.interactive().tint(.pink.opacity(0.2)), in: .capsule)
        .onAppear {
            // Start the infinite toggling
            isOn = true
        }
    }
}

#Preview {
    TypingIndicator()
        .scaleEffect(5)
        .padding(150)
}

