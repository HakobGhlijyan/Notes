//
//  Note.swift
//  Notes
//
//  Created by Hakob Ghlijyan on 01.10.2024.
//

import SwiftUI
import SwiftData

@Model
class Note: Identifiable {
    var id: String = UUID().uuidString
    var dataCreated: Date = Date()
    var colorString: String
    var title: String
    var content: String
    
    //View Properties
    var allowwHitTesting: Bool = false
    
    var color: Color {
        Color(colorString)
    }
    
    init(colorString: String, title: String, content: String) {
        self.colorString = colorString
        self.title = title
        self.content = content
    }
}
