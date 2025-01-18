//
//  RecipeResponse.swift
//  ForkedNetworking
//
//  Created by Thomas Rademaker on 1/18/25.
//

public struct RecipeResponse: Codable, Sendable {
    public let recipes: [RecipeDTO]
}
