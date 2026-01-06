//
//  MeshGradientBackground.swift
//  ElixChat
//
//  Created by Tim on 24/12/2025.
//
import SwiftUI
import Foundation

/// Абстрактний градієнтний фон для підсилення ефекту скла
struct MeshGradientBackground: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.4))
                    .frame(width: 400, height: 400)
                    .blur(radius: 60)
                    .offset(x: -100, y: -100)
                
                Circle()
                    .fill(Color.purple.opacity(0.4))
                    .frame(width: 300, height: 300)
                    .blur(radius: 50)
                    .offset(x: 200, y: 100)
                
                Circle()
                    .fill(Color.cyan.opacity(0.3))
                    .frame(width: 350, height: 350)
                    .blur(radius: 40)
                    .offset(x: 50, y: 300)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}
