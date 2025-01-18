//
//  RecipeDTO.swift
//  ForkedNetworking
//
//  Created by Thomas Rademaker on 1/18/25.
//

public struct RecipeDTO: Codable, Sendable {
    public var cuisine: String
    public var name: String
    public var photoUrlLarge: String?
    public var photoUrlSmall: String?
    public var uuid: String
    public var sourceUrl: String?
    public var youtubeUrl: String?
}
