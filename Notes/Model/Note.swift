//
//  Note.swift
//  Notes
//
//  Created by Hakob Ghlijyan on 01.10.2024.
//

import SwiftUI

struct Note: Identifiable {
    var id: String = UUID().uuidString
    var color: Color
    //View Properties
    var allowwHitTesting: Bool = false
}

var mockNotes: [Note] = [
    .init(color: .red),
    .init(color: .blue),
    .init(color: .green),
    .init(color: .yellow),
    .init(color: .purple),
    .init(color: .gray),
    .init(color: .cyan),
    .init(color: .brown),
    .init(color: .green),
    .init(color: .secondary),
    .init(color: .teal),
    .init(color: .blue),
    .init(color: .orange),
]
