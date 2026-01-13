//
//  NotesListView.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 26/12/25.
//

import SwiftUI

struct NotesListView: View {
    @EnvironmentObject var notesManager: NotesManager
    @EnvironmentObject var appState: AppState
    @State private var selectedNote: Note?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if notesManager.notes.isEmpty {
                    emptyStateView
                } else {
                    notesList
                }
            }
            .navigationTitle("Minhas Notas")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { appState.shouldShowNewNote = true }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(item: $selectedNote) { note in
                NoteDetailView(note: note)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Nenhuma nota ainda")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Pressione + para criar sua primeira nota\nou use Quick Actions!")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button(action: { appState.shouldShowNewNote = true }) {
                Label("Nova Nota", systemImage: "plus.circle.fill")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    private var notesList: some View {
        List {
            ForEach(notesManager.notes) { note in
                NoteRow(note: note)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedNote = note
                    }
            }
            .onDelete(perform: deleteNotes)
        }
        .listStyle(.plain)
    }
    
    private func deleteNotes(at offsets: IndexSet) {
        offsets.forEach { index in
            let note = notesManager.notes[index]
            notesManager.deleteNote(note)
        }
    }
}

struct NoteRow: View {
    let note: Note
    @EnvironmentObject var notesManager: NotesManager
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(note.title)
                    .font(.headline)
                
                Text(note.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(note.createdAt, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { notesManager.toggleFavorite(note) }) {
                Image(systemName: note.isFavorite ? "star.fill" : "star")
                    .foregroundColor(note.isFavorite ? .yellow : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NotesListView()
}
