//
//  Home.swift
//  Notes
//
//  Created by Hakob Ghlijyan on 01.10.2024.
//

import SwiftUI
import SwiftData

struct Home: View {
    @State private var searchText: String = ""
    @State private var selectedNote: Note?
    @State private var animateView: Bool = false
    
    @Query(sort: [.init(\Note.dataCreated, order: .reverse)], animation: .snappy) private var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                SearchBar()
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                    ForEach(notes) { note in
                        CardView(note)
                            .frame(height: 150)
                            .onTapGesture {
                                guard selectedNote == nil else { return }
                                
                                selectedNote = note
                                note.allowwHitTesting = true
                                
                                withAnimation(noteAnimantion) {
                                    animateView = true
                                }
                            }
                    }
                }
            }
        }
        .safeAreaPadding(15)
        .overlay {
            GeometryReader { _ in
                ForEach(notes) { note in
                    if note.id == selectedNote?.id && animateView {
                        DetalView(animation: animation, note: note)
                            .ignoresSafeArea(.container, edges: .top)
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomBar()
        }
    }
    
    //Custom Search bar with some basic components
    @ViewBuilder func SearchBar() -> some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $searchText)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(.primary.opacity(0.05), in: .rect(cornerRadius: 10))
    }
    
    @ViewBuilder func CardView(_ note: Note) -> some View {
        ZStack {
            if selectedNote?.id == note.id && animateView {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(note.color.gradient)
                    .matchedGeometryEffect(id: note.id, in: animation)
            }
        }
        
    }
    
    @ViewBuilder func BottomBar() -> some View {
        HStack(spacing: 15) {
            Button {
                if selectedNote == nil {
                    createEmptyNote()
                }
            } label: {
                Image(systemName: selectedNote == nil ? "plus.circle.fill" : "trash.fill")
                    .font(.title2)
                    .foregroundStyle( selectedNote == nil ? Color.primary : Color.red)
                    .contentShape(.rect)
                    .contentTransition(.symbolEffect(.replace))//animation change icon
            }
            
            Spacer(minLength: 0)
            
            if selectedNote != nil {
                Button {
                    if let firstIndex = notes.firstIndex(where: { $0.id == selectedNote?.id }) {
                        notes[firstIndex].allowwHitTesting = false
                    }
                    
                    withAnimation(noteAnimantion) {
                        animateView = false
                        selectedNote = nil
                    }
                } label: {
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.title3)
                        .foregroundStyle(Color.primary)
                        .contentShape(.rect)
                }
                .transition(.opacity)

            }
        }
        .overlay {
            Text("Notes")
                .font(.caption)
                .fontWeight(.semibold)
                .opacity(selectedNote != nil ? 0 : 1)
        }
        .overlay {
            if selectedNote != nil {
                CardColorPicker()
                    .transition(.blurReplace)
            }
        }
        .padding(15)
        .background(.bar)
        .animation(noteAnimantion, value: selectedNote != nil)
    }
    
    @ViewBuilder func CardColorPicker() -> some View {
        HStack(spacing: 10) {
            ForEach(1...5, id: \.self) { index in
                Circle()
                    .fill(.red.gradient)
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    func createEmptyNote() {
        let colors: [String] = (1...5).compactMap({ "Note \($0)" })
        let randomColor = colors.randomElement()!
        let note = Note(colorString: randomColor, title: "", content: "")
        modelContext.insert(note)
    }
}

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

#Preview {
    ContentView()
        .modelContainer(DataController.previewContainer)
    
}

struct DetalView: View {
    var animation: Namespace.ID
    var note: Note
    //View Properties
    @State private var animateLayer: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: animateLayer ? 0 : 10)
            .fill(note.color.gradient)
            .matchedGeometryEffect(id: note.id, in: animation)
            .transition(.offset(y: 1))
            .allowsHitTesting(note.allowwHitTesting)
            .onChange(of: note.allowwHitTesting, initial: true) { oldValue, newValue in
                withAnimation(noteAnimantion) {
                    animateLayer = newValue
                }
            }
    }
}

extension View {
    var noteAnimantion: Animation {
        .smooth(duration: 0.3, extraBounce: 0)
    }
}
