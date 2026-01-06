////
////  SettingsView.swift
////  ElixChat
////
////  Created by Tim on 24/12/2025.
////
//
//import SwiftUI
//import Observation
//
//struct SettingsView: View {
//    @Environment(\.dismiss) var dismiss
//    var viewModel: AppViewModel
//    
//    var body: some View {
//        
//        ZStack {
//            MeshGradientBackground().opacity(0.2) // Subtle bg through glass
//            
//            VStack(spacing: 0) {
//                // Handle
//                Capsule()
//                    .fill(.secondary.opacity(0.3))
//                    .frame(width: 40, height: 5)
//                    .padding(.top, 12)
//                
//                HStack {
//                    Text("Налаштування Eney")
//                        .font(.system(.title3, design: .rounded, weight: .semibold))
//                    Spacer()
//                    Button(action: { dismiss() }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .font(.title2)
//                            .foregroundStyle(.secondary)
//                    }
//                    .buttonStyle(.plain)
//                }
//                .padding(20)
//                
//                ScrollView {
//                    VStack(spacing: 24) {
//                        // Model Section (Glass Card)
//                        VStack(alignment: .leading, spacing: 16) {
//                            Label("Модель та Доступ", systemImage: "cpu")
//                                .font(.headline)
//                            
//                            VStack(alignment: .leading) {
//                                Text("Hugging Face Token")
//                                    .font(.caption).foregroundStyle(.secondary)
//                                SecureField("hf_...", text: $vm.engineConfig.hfToken)
//                                    .textFieldStyle(.plain)
//                                    .padding(10)
//                                    .background(.black.opacity(0.1))
//                                    .cornerRadius(8)
//                                    .onChange(of: vm.engineConfig.hfToken) { viewModel.updateToken(vm.engineConfig.hfToken) }
//                            }
//                            
//                            VStack(alignment: .leading) {
//                                Text("Шлях до моделей")
//                                    .font(.caption).foregroundStyle(.secondary)
//                                TextField("~/Documents/...", text: $vm.engineConfig.modelPath)
//                                    .textFieldStyle(.plain)
//                                    .padding(10)
//                                    .background(.black.opacity(0.1))
//                                    .cornerRadius(8)
//                            }
//                            
//                            // Автозапуск
//                            Toggle(isOn: $vm.engineConfig.autoInitialize) {
//                                Text("Ініціалізувати при запуску")
//                                    .font(.body)
//                            }
//                            .toggleStyle(.switch)
//                            .onChange(of: vm.engineConfig.autoInitialize) { viewModel.updateSettings() }
//                            
//                            Divider().opacity(0.3)
//                            
//                            Button(action: { viewModel.initializeEngine() }) {
//                                HStack {
//                                    if viewModel.isEngineLoading {
//                                        ProgressView().controlSize(.small)
//                                    }
//                                    Text("Ініціалізувати двигун зараз")
//                                }
//                                .frame(maxWidth: .infinity)
//                                .padding(10)
//                                .background(Color.blue.opacity(0.2))
//                                .cornerRadius(10)
//                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue.opacity(0.5), lineWidth: 1))
//                            }
//                            .buttonStyle(.plain)
//                        }
//                        .padding(20)
//                        .liquidGlass(material: .thin)
//                        
//                        // Parameters Section (Glass Card)
//                        VStack(alignment: .leading, spacing: 20) {
//                            Label("Генерація", systemImage: "waveform.path.ecg")
//                                .font(.headline)
//                            
//                            VStack(spacing: 8) {
//                                HStack {
//                                    Text("Temperature")
//                                    Spacer()
//                                    Text(String(format: "%.1f", viewModel.engineConfig.temperature))
//                                        .padding(4)
//                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
//                                }
//                                
//                                Slider(value: $vm.engineConfig.temperature, in: 0.0...1.5, step: 0.1)
//                                    .tint(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
//                                    .onChange(of: vm.engineConfig.temperature) { viewModel.updateSettings() }
//                            }
//                            
//                            VStack(spacing: 8) {
//                                HStack {
//                                    Text("Max Tokens")
//                                    Spacer()
//                                    Text("\(viewModel.engineConfig.maxTokens)")
//                                        .padding(4)
//                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
//                                }
//                                
//                                Slider(value: Binding(
//                                    get: { Double(viewModel.engineConfig.maxTokens) },
//                                    set: { viewModel.engineConfig.maxTokens = Int($0) }
//                                ), in: 128...4096, step: 128)
//                                .onChange(of: vm.engineConfig.maxTokens) { viewModel.updateSettings() }
//                            }
//                        }
//                        .padding(20)
//                        .liquidGlass(material: .thin)
//                    }
//                    .padding()
//                }
//            }
//        }
//        .background(.ultraThinMaterial) // Base material for the sheet
//    }
//}
//
//
//#Preview {
//    SettingsView(viewModel: AppViewModel(service: LLMService()))
//}
