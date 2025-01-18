//
//  ForkedNetworking.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI
import SwiftData
import ForkedNetworking

@Observable
class Services {
    let run: ServicesModelActor
    
    init(servicesModelActor: ServicesModelActor) {
        run = servicesModelActor
    }
}

@ModelActor
actor ServicesModelActor {
    
    func getAllRecipes() async {
        guard let recipeResponse = try? await RecipeService().getAll() else { return } // TODO: we should handle this error
        handleRecipeResponse(recipeResponse)
    }
    
    func getMalformedRecipes() async {
        guard let recipeResponse = try? await RecipeService().getMalformed() else { return } // TODO: we should handle this error
        handleRecipeResponse(recipeResponse)
    }
    
    func getEmptyRecipes() async {
        guard let recipeResponse = try? await RecipeService().getEmpty() else { return } // TODO: we should handle this error
        handleRecipeResponse(recipeResponse)
    }
    
    private func handleRecipeResponse(_ recipeResponse: RecipeResponse) {
        for recipeDTO in recipeResponse.recipes {
            guard let recipeDTO else { continue }
            let recipe = Recipe(cuisine: recipeDTO.cuisine, name: recipeDTO.name, photoUrlLarge: recipeDTO.photoUrlLarge, photoUrlSmall: recipeDTO.photoUrlSmall, uuid: recipeDTO.uuid, sourceUrl: recipeDTO.sourceUrl, youtubeUrl: recipeDTO.youtubeUrl)
            modelContext.insert(recipe)
        }
        
        try? modelContext.save() // TODO: we should handle this error
    }
}

struct ServicesViewModifier: ViewModifier {
    @Environment(\.modelContext) private var modelContext
    
    func body(content: Content) -> some View {
        content
            .environment(Services(servicesModelActor: ServicesModelActor(modelContainer: modelContext.container)))
    }
}

extension View {
    func setupServices() -> some View {
        modifier(ServicesViewModifier())
    }
}
