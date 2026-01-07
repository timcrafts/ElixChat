//
//  MeshGradientBackground.swift
//  ElixChat
//
//  Created by Tim on 24/12/2025.
//
import SwiftUI
import Foundation

/// Абстрактний градієнтний фон для підсилення ефекту скла
struct MeshGradientBackground2: View {
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

struct MeshGradientBackground: View {

    var body: some View {
        MeshGradient(width: 3, height: 3,
            points: [
                [0.0, 0.0], [0.6, 0.0], [1.0, 0.0],
                [0.0, 0.2], [0.8, 0.5], [1.0, 0.8],
                [0.0, 1.0], [0.3, 1.0], [1.0, 1.0]
            ],
            colors: [
                Color(red: 252/255, green: 94/255, blue: 186/255),
                Color(red: 200/255, green: 41/255, blue: 255/255),
                Color(red: 255/255, green: 146/255, blue: 220/255),
                Color(red: 200/255, green: 41/255, blue: 255/255),
                Color(red: 200/255, green: 41/255, blue: 1),
                Color(red: 255/255, green: 211/255, blue: 246/255),
                Color(red: 252/255, green: 94/255, blue: 186/255),
                Color(red: 255/255, green: 211/255, blue: 246/255),
                Color(red: 200/255, green: 41/255, blue: 1),
                Color(red: 255/255, green: 146/255, blue: 220/255)
            ]
        )
        .opacity(0.3)
        
    }
}

#Preview {
    MeshGradientBackground()
}
#Preview {
    MeshGradientBackground2()
}
