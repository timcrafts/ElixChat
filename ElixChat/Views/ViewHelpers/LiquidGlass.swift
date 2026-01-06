//
//  Views.swift
//  ElixChat
//
//  Created by Tim on 23/12/2025.
//

import Foundation
import SwiftUI

// --- Liquid Glass Design System ---

/// Модифікатор для імітації матеріалу "Liquid Glass" (Рідке Скло)
/// Додає розмиття, напівпрозорий фон та світловий контур.
struct LiquidGlassModifier: ViewModifier {
    var material: Material = .ultraThin
    var cornerRadius: CGFloat = 20
    var borderOpacity: Double = 0.3
    
    func body(content: Content) -> some View {
        content
            .background(material)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .white.opacity(borderOpacity),
                                .white.opacity(0.05),
                                .white.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

extension View {
    func liquidGlass(material: Material = .ultraThin, radius: CGFloat = 20) -> some View {
        self.modifier(LiquidGlassModifier(material: material, cornerRadius: radius))
    }
}
















