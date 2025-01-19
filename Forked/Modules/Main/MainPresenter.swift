//
//  MainPresenter.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI
import SwiftData
import ForkedNetworking

struct MainPresenter: View {
    @Environment(MainState.self) private var state
    
    var body: some View {
        @Bindable var state = state
        
        NavigationStack(path: $state.path) {
            MainView()
                .navigationDestination(for: MainState.Path.self) {
                    switch $0 {
                    case .recipe(let recipe):
                        RecipePresenter(recipe: recipe)
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
    @Environment(Services.self) private var services
    @Query private var recipes: [Recipe]
    @State private var sortDescriptor: SortDescriptor<Recipe> = SortDescriptor(\.name)
    @State private var apiEndpoint: RecipeAPI = .all
    
    var body: some View {
        List {
            SortedRecipeList(sortDescriptor: sortDescriptor)
                .opacity(recipes.count == 0 ? 0 : 1)
            ContentUnavailableView("No recipes from \(apiEndpoint.title) endpoint", systemImage: "carrot", description: Text("Pull to refresh"))
                .listRowBackground(Color.clear)
                .opacity(recipes.count == 0 ? 1 : 0)
        }
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Forked")
                    Image(systemName: "fork.knife")
                }
                .font(.title3)
                .foregroundStyle(Color.accentColor)
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("", systemImage: "trash.circle", action: askToDeleteRecipes)
                
                Menu {
                    Menu("Sort by") {
                        Picker("sort by", selection: $sortDescriptor) {
                            Text("name")
                                .tag(SortDescriptor(\Recipe.name))
                            Text("cuisine")
                                .tag(SortDescriptor(\Recipe.cuisine))
                        }
                    }
                    
                    Menu("API Endpoint") {
                        Picker("API", selection: $apiEndpoint) {
                            Text("all")
                                .tag(RecipeAPI.all)
                            Text("malformed")
                                .tag(RecipeAPI.malformed)
                            Text("empty")
                                .tag(RecipeAPI.empty)
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onChange(of: state.triggerDelete, deleteRecipes)
        .onChange(of: apiEndpoint, updateAPIEndpoint)
        .task { await getRecipes() }
        .refreshable { await getRecipes() }
    }
    
    func getRecipes() async {
        guard !isCanvas else { return } // don't hit network if in SwiftUI canvas
        
        switch apiEndpoint {
        case .all: await services.run.getAllRecipes()
        case .malformed: await services.run.getMalformedRecipes()
        case .empty: await services.run.getEmptyRecipes()
        }
    }
    
    func updateAPIEndpoint() {
        deleteRecipes()
    }
    
    func askToDeleteRecipes() {
        state.askToDelete.toggle()
    }
    
    func deleteRecipes() {
        guard !isCanvas else { return } // don't delete if in SwiftUI canvas
        do {
            let fetchDescriptor = FetchDescriptor<Recipe>()
            let recipes = try modelContext.fetch(fetchDescriptor)
            
            for recipe in recipes {
                modelContext.delete(recipe)
            }
            
            try modelContext.save()
        } catch {
            print("Failed to fetch or delete recipes: \(error.localizedDescription)")
        }
    }
}

fileprivate struct SortedRecipeList: View {
    @Query private var recipes: [Recipe]
    let sortDescriptor: SortDescriptor<Recipe>
    
    init(sortDescriptor: SortDescriptor<Recipe>) {
        self.sortDescriptor = sortDescriptor
        _recipes = Query(sort: [sortDescriptor])
    }
    
    var body: some View {
        if sortDescriptor.keyPath == \Recipe.cuisine {
            // Group recipes by cuisine when sorting by cuisine
            ForEach(groupedRecipes.keys.sorted(), id: \.self) { cuisine in
                Section(header: Text(cuisine)) {
                    ForEach(groupedRecipes[cuisine] ?? []) { recipe in
                        RecipeCell(recipe: recipe)
                    }
                }
            }
        } else {
            // Regular list without sections for other sort descriptors
            ForEach(recipes) { recipe in
                RecipeCell(recipe: recipe)
            }
        }
    }
    
    private var groupedRecipes: [String: [Recipe]] {
        Dictionary(grouping: recipes) { $0.cuisine }
    }
}

fileprivate struct RecipeCell: View {
    let recipe: Recipe
    
    var body: some View {
        NavigationLink(value: MainState.Path.recipe(recipe)) {
            HStack {
                ForkedImage(image: .url(url: recipe.photoUrlSmall, sfSymbol: "photo"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: 50, height: 50)
                
                Text(recipe.name)
            }
        }
    }
}

#if DEBUG
#Preview(traits: .sampleRecipes) {
    MainPresenter()
        .environment(MainState(parentState: AppState()))
        .setupServices()
}
#endif
