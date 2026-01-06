//
//  ElixChatApp.swift
//  ElixChat
//
//  Created by Tim on 23/12/2025.
//

import SwiftUI

@main
struct ElixChatApp: App {
    // Створюємо StateObject вручну в init, щоб передати залежності
    private var appViewModel: AppViewModel
    
    init() {
        // 1. Створюємо конфігурацію
        let config = EngineConfiguration()
        
        // 2. Створюємо сервіс (тут буде жити наш EneyLocal)
        let service = LLMService()
        
        // 3. Ініціалізуємо ViewModel з цим сервісом
        appViewModel = AppViewModel(service: service)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                // Передаємо ViewModel як EnvironmentObject, щоб доступ був всюди
                .environment(appViewModel)
        }
    }
}

