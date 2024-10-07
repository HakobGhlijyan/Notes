//
//  DetalView.swift
//  Notes
//
//  Created by Hakob Ghlijyan on 07.10.2024.
//

import SwiftUI

struct DetalView: View {
    let size: CGSize
    var titleNoteSize: CGSize
    var animation: Namespace.ID
    //You can make a swiftdata momdel into a bindable objects by simple using the @Bindable wrapper
    @Bindable var note: Note
    //View Properties
    @State private var animateLayer: Bool = false
    
    var body: some View {
        Rectangle()
            .fill(note.color.gradient)
            .overlay(alignment: .topLeading, content: {
                TitleNoteView(size: titleNoteSize, note: note)
                    .blur(radius: animateLayer ? 100 : 0)
                    .opacity(animateLayer ? 0 : 1)
            })
            .overlay {
                NotesContext()
            }
            .clipShape(.rect(cornerRadius: animateLayer ? 0 : 10))
            .matchedGeometryEffect(id: note.id, in: animation)
            .transition(.offset(y: 1))
            .allowsHitTesting(note.allowwHitTesting)
            .onChange(of: note.allowwHitTesting, initial: true) { oldValue, newValue in
                withAnimation(noteAnimantion) {
                    animateLayer = newValue
                }
            }
    }
    
    @ViewBuilder func NotesContext() -> some View {
        GeometryReader {
            let currrenSize: CGSize = $0.size
            
            VStack(alignment: .leading, spacing: 15) {
                TextField("Title", text: $note.title, axis: .vertical)
                    .font(.title)
                    .lineLimit(2)
                
                TextEditor(text: $note.content)
                    .font(.title3)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .overlay(alignment: .topLeading, content: {
                        if note.content.isEmpty {
                            Text("Add a Note...")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                                .offset(x: 8, y: 8)
                        }
                    })
                
            }
            .tint(.white)
            .padding(15)
            .padding(.top, safeArea.top)
            .frame(width: size.width, height: size.height)
            .frame(width: currrenSize.width, height: currrenSize.height, alignment: .topLeading)
        }
        .blur(radius: animateLayer ? 0 : 100)
        .opacity(animateLayer ? 1 : 0)
    }
    
    var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
            return safeArea
        }
        return .zero
    }
    
}
