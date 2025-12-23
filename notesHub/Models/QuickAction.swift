//
//  QuickAction.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 23/12/25.
//

import Foundation
import UIKit

enum QuickAction: String {
    case newNote = "com.noteshub.newnote"
    case search = "com.noteshub.search"
    case favorites = "com.noteshub.favorites"
    
    init?(shortcutItem: UIApplicationShortcutItem) {
        guard let action = QuickAction(rawValue: shortcutItem.type) else {
            return nil
        }
        self = action
    }
    
    var title: String {
        switch self {
        case .newNote: return "Nova Nota"
        case .search: return "Buscar"
        case .favorites: return "Favoritas"
        }
    }
    
    var icon: String {
        switch self {
        case .newNote: return "square.and.pencil"
        case .search: return "magnifyingglass"
        case .favorites: return "star.fill"
        }
    }
}
