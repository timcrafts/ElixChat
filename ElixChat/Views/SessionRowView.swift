//
//  SessionRowView.swift
//  ElixChat
//
//  Created by Tim on 24/12/2025.
//

import SwiftUI

struct SessionRowView: View {
    let session: ChatSession
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.title)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(isSelected ? .semibold : .regular)
                        .lineLimit(1)
                        .foregroundColor(isSelected ? .primary : .primary.opacity(0.8))
                    
                    Text(session.lastModified, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(12)
            .background(isSelected ? Material.thin : Material.ultraThin) // Glass Effect
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.white.opacity(0.2) : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

//#Preview {
//    SessionRowView(session: , isSelected: <#T##Bool#>, action: <#T##() -> Void#>)
//}
