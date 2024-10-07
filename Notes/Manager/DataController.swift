//
//  DataController.swift
//  Notes
//
//  Created by Hakob Ghlijyan on 02.10.2024.
//

import SwiftUI
import SwiftData

@MainActor
class DataController {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Note.self, configurations: config)

            let colors: [String] = (1...5).compactMap({ "Note \($0)" })
            let randomColor = colors.randomElement()!
            
            let note = Note(colorString: randomColor, title: "", content: "")
            container.mainContext.insert(note)

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
