//
//  SearchNotesView.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 26/12/25.
//

import SwiftUI

struct SearchNotesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var notesManager: NotesManager
    @State private var searchText = ""
    @State private var selectedNote: Note?
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notesManager.notes
        }
        return notesManager.notes.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                    .padding()
                
                if filteredNotes.isEmpty {
                    emptySearchView
                } else {
                    searchResultsList
                }
            }
            .navigationTitle("Buscar Notas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fechar") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedNote) { note in
                NoteDetailView(note: note)
            }
        }
    }
    
    private var emptySearchView: some View {
        VStack(spacing: 16) {
            Image(systemName: searchText.isEmpty ? "magnifyingglass" : "doc.text.magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text(searchText.isEmpty ? "Digite para buscar" : "Nenhuma nota encontrada")
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
    
    private var searchResultsList: some View {
        List(filteredNotes) { note in
            NoteRow(note: note)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedNote = note
                }
        }
        .listStyle(.plain)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar notas...", text: $text)
                .textFieldStyle(.plain)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    SearchNotesView()
}
