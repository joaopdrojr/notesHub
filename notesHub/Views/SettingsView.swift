//
//  SettingsView.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 26/12/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var notesManager: NotesManager
    @State private var notificationsEnabled = true
    @State private var syncEnabled = false
    @State private var showingClearAlert = false
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Quick Actions") {
                    QuickActionInfoRow(
                        icon: "square.and.pencil",
                        title: String(localized: "Nova Nota"),
                        description: String(localized: "Cria uma nota rapidamente")
                    )
                    QuickActionInfoRow(
                        icon: "magnifyingglass",
                        title: String(localized: "Buscar"),
                        description: String(localized: "Pesquisa em suas notas")
                    )
                    QuickActionInfoRow(
                        icon: "star.fill",
                        title: String(localized: "Favoritas"),
                        description: String(localized: "Acessa notas favoritas")
                    )
                }
                
                Section("Preferências") {
                    Toggle("Notificações", isOn: $notificationsEnabled)
                }
                
                Section("Dados") {
                    HStack {
                        Text("Total de Notas")
                        Spacer()
                        Text("\(notesManager.notes.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Notas Favoritas")
                        Spacer()
                        Text("\(notesManager.favoriteNotes.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    Button(role: .destructive) {
                        showingResetAlert = true
                    } label: {
                        Text("Restaurar Notas de Exemplo")
                    }
                    
                    Button(role: .destructive) {
                        showingClearAlert = true
                    } label: {
                        Text("Limpar Todas as Notas")
                    }
                }
                
                Section("Sobre") {
                    HStack {
                        Text("App")
                        Spacer()
                        Text("NotesHub")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Versão")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Persistência")
                        Spacer()
                        Text("UserDefaults")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Feito por")
                        Spacer()
                        Text("João Pedro (JP)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Text("Demonstração de Quick Actions em SwiftUI. Pressione e segure o ícone do app para acesso rápido! As notas são salvas automaticamente no dispositivo.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Configurações")
            .alert("Limpar Todas as Notas?", isPresented: $showingClearAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Limpar", role: .destructive) {
                    notesManager.clearAllNotes()
                }
            } message: {
                Text("Esta ação não pode ser desfeita. Todas as notas serão removidas permanentemente.")
            }
            .alert("Restaurar Notas de Exemplo?", isPresented: $showingResetAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Restaurar", role: .destructive) {
                    notesManager.resetToSampleNotes()
                }
            } message: {
                Text("Suas notas atuais serão substituídas pelas notas de exemplo.")
            }
        }
    }
}

#Preview {
    SettingsView()
}
