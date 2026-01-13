//
//  NewNoteView.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 26/12/25.
//

import SwiftUI

struct NewNoteView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var notesManager: NotesManager
    @State private var title = ""
    @State private var content = ""
    @State private var showingSuccessAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TextField("Título da nota", text: $title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                Divider()
                
                TextEditor(text: $content)
                    .padding()
            }
            .navigationTitle("Nova Nota")
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
                    .disabled(title.isEmpty)
                }
            }
            .alert("Nota Criada!", isPresented: $showingSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Sua nota '\(title)' foi salva com sucesso!")
            }
        }
    }
    
    private func saveNote() {
        let newNote = Note(
            title: title,
            content: content.isEmpty ? "Sem conteúdo" : content
        )
        notesManager.addNote(newNote)
        showingSuccessAlert = true
    }
}

#Preview {
    NewNoteView()
}
