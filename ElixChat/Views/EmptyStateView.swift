//
//  EmptyStateView.swift
//  ElixChat
//
//  Created by Tim on 24/12/2025.
//

import SwiftUI
import Foundation

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles.rectangle.stack")
                .font(.system(size: 60))
                .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .symbolEffect(.pulse, options: .repeating)
            
            Text("Eney Local")
                .font(.system(size: 32, weight: .thin, design: .rounded))
            
            Text("Виберіть чат або створіть новий, щоб почати діалог.")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .liquidGlass(material: .ultraThin, radius: 30)
    }
}

#Preview {
    EmptyStateView()
}