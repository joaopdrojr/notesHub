//
//  NotesManager.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 26/12/25.
//

import Foundation
import Combine

class NotesManager: ObservableObject {
    @Published var notes: [Note] = []
    
    private let userDefaultsKey = "savedNotes"
    
    init() {
        loadNotes()
    }
    
    func addNote(_ note: Note) {
        notes.insert(note, at: 0)
        saveNotes()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            var updatedNote = note
            updatedNote.updatedAt = Date()
            notes[index] = updatedNote
            saveNotes()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    func toggleFavorite(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isFavorite.toggle()
            notes[index].updatedAt = Date()
            saveNotes()
        }
    }
    
    var favoriteNotes: [Note] {
        notes.filter { $0.isFavorite }
    }
    
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded
        } else {
            loadSampleNotes()
        }
    }
    
    private func loadSampleNotes() {
        notes = [
            Note(title: "Ideias para o App", content: "Implementar Quick Actions para acesso rápido às funcionalidades mais usadas.", isFavorite: true),
            Note(title: "Lista de Compras", content: "Leite, Pão, Café, Frutas"),
            Note(title: "SwiftUI Tips", content: "Usar @StateObject para objetos que o view possui\nUsar @ObservedObject para objetos passados de fora", isFavorite: true),
            Note(title: "Reunião Segunda", content: "Discutir arquitetura do novo projeto\n- MVVM\n- Clean Architecture\n- Dependency Injection"),
            Note(title: "Livros para Ler", content: "1. Clean Code\n2. Design Patterns\n3. Swift Programming", isFavorite: false)
        ]
        saveNotes()
    }
    
    func clearAllNotes() {
        notes.removeAll()
        saveNotes()
    }
    
    func resetToSampleNotes() {
        notes.removeAll()
        loadSampleNotes()
    }
}
