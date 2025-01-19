//
//  RecipePresenter.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI
import SwiftData

struct RecipePresenter: View {
    let recipe: Recipe
    
    var body: some View {
        RecipeView(recipe: recipe)
    }
}

fileprivate struct RecipeView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: recipe.photoUrlLarge ?? ""), content: {
                    $0
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }, placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                })
                
                RecipeNameView(name: recipe.name)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Text("Cuisine:")
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                Spacer()
            }
            .padding(.leading)
            
            Spacer()
            
            RecipeCTAs(recipe: recipe)
            
        }
    }
}

fileprivate struct RecipeNameView: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.title)
            .padding(4)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
    }
}

fileprivate struct RecipeCTAs: View {
    @Environment(\.openURL) private var openURL
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: openLink) {
                Text("Visit")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(recipe.sourceUrl == nil)
            .opacity(recipe.sourceUrl == nil ? 0 : 1)
            
            Button(action: openYoutubeLink) {
                Text("Watch")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(recipe.youtubeUrl == nil)
            .opacity(recipe.youtubeUrl == nil ? 0 : 1)
        }
        .padding()
    }
    
    private func openLink() {
        openLink(with: recipe.sourceUrl)
    }
    
    private func openYoutubeLink() {
        openLink(with: recipe.youtubeUrl)
    }
    
    private func openLink(with urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else { return }
        openURL(url)
    }
}

#if DEBUG
#Preview(traits: .sampleRecipes) {
    @Previewable @Query(sort: \Recipe.name) var recipes: [Recipe]
    RecipePresenter(recipe: recipes.first!)
}
#endif
