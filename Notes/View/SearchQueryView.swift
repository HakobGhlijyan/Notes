//
//  SearchQueryView.swift
//  Notes
//
//  Created by Hakob Ghlijyan on 07.10.2024.
//

import SwiftUI
import SwiftData

struct SearchQueryView<Content: View>: View {
    var content: ([Note]) -> Content
    
    @Query var notes: [Note]
    
    init(searchText: String, @ViewBuilder content: @escaping ([Note]) -> Content) {
        self.content = content
        
        let isSearchTextEmpty = searchText.isEmpty
        
        let predicate = #Predicate<Note> {
            return isSearchTextEmpty || $0.title.localizedStandardContains(searchText)
            
        }
        
        _notes = .init(filter: predicate, sort: [.init(\.dataCreated, order: .reverse)], animation: .snappy)
    }
    
    var body: some View {
        content(notes)
    }
}

