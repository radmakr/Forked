//
//  MainPresenter.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI
import SwiftData

struct MainPresenter: View {
    @Environment(MainState.self) private var state
    
    var body: some View {
        @Bindable var state = state
        
        NavigationStack(path: $state.path) {
            MainView()
                .navigationDestination(for: MainState.Path.self) {
                    switch $0 {
                    case .recipe(let recipe):
                        Text(recipe.name)
                    }
                }
                .alert("Delete All Recipes?", isPresented: $state.askToDelete) {
                    Button("Yes", role: .destructive, action: deleteRecipes)
                } message: {
                    Text("Delete all cached Recipes. A pull to refresh is required to bring them back")
                }
        }
    }
    
    private func deleteRecipes() {
        state.triggerDelete.toggle()
    }
}

fileprivate struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MainState.self) private var state
    @Query private var recipes: [Recipe]
    @State private var sortDescriptor: SortDescriptor<Recipe> = SortDescriptor(\.name)
    
    var body: some View {
        ZStack {
            SortedRecipeList(sortDescriptor: sortDescriptor)
                .opacity(recipes.count == 0 ? 0 : 1)
            ContentUnavailableView("No recipes", systemImage: "", description: Text("Pull to refresh"))
                .opacity(recipes.count == 0 ? 1 : 0)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Fetch Recipe")
                    Image(systemName: "fork.knife")
                }
                .font(.title3)
                .foregroundStyle(Color.accentColor)
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("", systemImage: "trash.circle", action: askToDeleteRecipes)
                
                Menu {
                    Picker("sort by", selection: $sortDescriptor) {
                        Text("name")
                            .tag(SortDescriptor(\Recipe.name))
                        Text("cuisine")
                            .tag(SortDescriptor(\Recipe.cuisine))
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onChange(of: state.triggerDelete, deleteRecipes)
    }
    
    func askToDeleteRecipes() {
        state.askToDelete.toggle()
    }
    
    func deleteRecipes() {
        do {
            let fetchDescriptor = FetchDescriptor<Recipe>()
            let recipes = try modelContext.fetch(fetchDescriptor)
            
            for recipe in recipes {
                modelContext.delete(recipe)
            }
            
            try modelContext.save()
        } catch {
            print("Failed to fetch or delete recipes: \(error)")
        }
    }
}

fileprivate struct SortedRecipeList: View {
    @Query private var recipes: [Recipe]
    
    init(sortDescriptor: SortDescriptor<Recipe>) {
        _recipes = Query(sort: [sortDescriptor])
    }
    
    var body: some View {
        List {
            ForEach(recipes) {
                RecipeCell(recipe: $0)
            }
        }
        .scrollIndicators(.hidden)
    }
}

fileprivate struct RecipeCell: View {
    let recipe: Recipe
    
    var body: some View {
        NavigationLink(value: MainState.Path.recipe(recipe)) {
            Text(recipe.name)
        }
    }
}

#if DEBUG
#Preview(traits: .sampleRecipes) {
    MainPresenter()
        .environment(MainState(parentState: AppState()))
}
#endif
