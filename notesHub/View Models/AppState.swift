//
//  AppState.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 26/12/25.
//

import Foundation
import Combine

class AppState: ObservableObject {
    @Published var selectedTab: Tab = .notes
    @Published var shouldShowNewNote: Bool = false
    @Published var shouldShowSearch: Bool = false
    @Published var shouldShowFavoritesAlert: Bool = false
    @Published var lastActionTriggered: String = ""
    
    enum Tab {
        case notes
        case favorites
        case settings
    }
    
    func handle(_ quickAction: QuickAction) {
        lastActionTriggered = quickAction.title
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            switch quickAction {
            case .newNote:
                self.shouldShowNewNote = true
            case .search:
                self.shouldShowSearch = true
            case .favorites:
                self.selectedTab = .favorites
                self.shouldShowFavoritesAlert = true
            }
        }
    }
    
    func reset() {
        shouldShowNewNote = false
        shouldShowSearch = false
        shouldShowFavoritesAlert = false
    }
}
