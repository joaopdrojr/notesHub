//
//  FavoritesView.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 26/12/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var notesManager: NotesManager
    @EnvironmentObject var appState: AppState
    @State private var selectedNote: Note?
    
    var body: some View {
        NavigationView {
            Group {
                if notesManager.favoriteNotes.isEmpty {
                    emptyFavoritesView
                } else {
                    favoritesList
                }
            }
            .navigationTitle("Notas Favoritas")
            .sheet(item: $selectedNote) { note in
                NoteDetailView(note: note)
            }
        }
    }
    
    private var emptyFavoritesView: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Nenhuma nota favorita")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Toque na estrela ⭐ em qualquer nota para marcá-la como favorita")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .frame(maxHeight: .infinity)
    }
    
    private var favoritesList: some View {
        List(notesManager.favoriteNotes) { note in
            NoteRow(note: note)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedNote = note
                }
        }
        .listStyle(.plain)
    }
}

#Preview {
    FavoritesView()
}
