//
//  Note.swift
//  notesHub
//
//  Created by Joao Pedro Junior on 22/12/25.
//

import Foundation

struct Note: Identifiable, Codable{
    let id: UUID
    var title: String
    var content: String
    var isFavorite: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(), title: String, content: String, isFavorite: Bool = false){
        self.id = id
        self.title = title
        self.content = content
        self.isFavorite = isFavorite
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
