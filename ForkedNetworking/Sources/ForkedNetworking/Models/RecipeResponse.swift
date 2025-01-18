//
//  RecipeResponse.swift
//  ForkedNetworking
//
//  Created by Thomas Rademaker on 1/18/25.
//

public struct RecipeResponse: Codable, Sendable {
    public let recipes: [RecipeDTO?]
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let recipesArray = try container.decode([RecipeDecodingContainer].self, forKey: .recipes)
        
        self.recipes = recipesArray.map { container in
            return container.recipe
        }
    }
    
    private struct RecipeDecodingContainer: Codable {
        let recipe: RecipeDTO?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            recipe = try? container.decode(RecipeDTO.self)
        }
    }
}
