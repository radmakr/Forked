//
//  ForkedModel.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI
import SwiftData

struct ForkedModelViewModifier: ViewModifier {
    let container: ModelContainer
    let schema = Schema([
        Recipe.self
    ])
    
    init(inMemory: Bool) {
        do {
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
            container = try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Failed to create ModelContainer")
        }
    }
    
    func body(content: Content) -> some View {
        content
            .modelContainer(container)
    }
}

extension View {
    func setupModel(inMemory: Bool = false) -> some View {
        modifier(ForkedModelViewModifier(inMemory: inMemory))
    }
}

