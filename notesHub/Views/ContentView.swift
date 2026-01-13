//
//  ContentView.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 21/12/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var notesManager: NotesManager
    
    var body: some View {
        TabView(selection: $appState.selectedTab){
            NotesListView()
                .tabItem{
                    Label("Notas", systemImage: "note.text")
                }
                .tag(AppState.Tab.notes)
            
            FavoritesView()
                .tabItem{
                    Label("Favoritos", systemImage: "star.fill")
                }
                .tag(AppState.Tab.favorites)
            
            SettingsView()
                .tabItem{
                    Label("Configurações", systemImage: "gear")
                }
                .tag(AppState.Tab.settings)
        }
        .sheet(isPresented: $appState.shouldShowNewNote){
            NewNoteView()
                .onDisappear{
                    appState.reset()
                }
        }
        .sheet(isPresented: $appState.shouldShowSearch){
            SearchNotesView()
                .onDisappear{
                    appState.reset()
                }
        }
    }
}

#Preview {
    ContentView()
}
