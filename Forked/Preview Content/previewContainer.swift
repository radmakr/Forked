//
//  previewContainer.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI
import SwiftData
import ForkedNetworking

#if DEBUG
struct SampleDataRecipes: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(for: Recipe.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        if let recipeResponse: RecipeResponse = object(resourceName: "recipes") {
            for recipeDTO in recipeResponse.recipes {
                guard let recipeDTO else { continue }
                let recipe = Recipe(cuisine: recipeDTO.cuisine, name: recipeDTO.name, photoUrlLarge: recipeDTO.photoUrlLarge, photoUrlSmall: recipeDTO.photoUrlSmall, uuid: recipeDTO.uuid, sourceUrl: recipeDTO.sourceUrl, youtubeUrl: recipeDTO.youtubeUrl)
                container.mainContext.insert(recipe)
            }
        }
        
        try container.mainContext.save()
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleRecipes: Self = .modifier(SampleDataRecipes())
}

fileprivate func object<c: Codable>(resourceName: String) -> c? {
    guard let file = Bundle.main.url(forResource: resourceName, withExtension: "json"),
          let data = try? Data(contentsOf: file) else { return nil }
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try? decoder.decode(c.self, from: data)
}

#endif
