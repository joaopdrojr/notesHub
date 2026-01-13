//
//  NoteDetailView.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 26/12/25.
//

import SwiftUI

struct NoteDetailView: View {
    let note: Note
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var notesManager: NotesManager
    
    @State private var editedTitle: String
    @State private var editedContent: String
    
    init(note: Note) {
        self.note = note
        _editedTitle = State(initialValue: note.title)
        _editedContent = State(initialValue: note.content)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TextField("Título", text: $editedTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                Divider()
                
                TextEditor(text: $editedContent)
                    .padding()
            }
            .navigationTitle("Editar Nota")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        saveNote()
                    }
                    .disabled(editedTitle.isEmpty)
                }
            }
        }
    }
    
    private func saveNote() {
        var updatedNote = note
        updatedNote.title = editedTitle
        updatedNote.content = editedContent
        updatedNote.updatedAt = Date()
        notesManager.updateNote(updatedNote)
        dismiss()
    }
}


