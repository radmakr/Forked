//
//  Recipe.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftData

@Model
class Recipe {
    var cuisine: String
    var name: String
    var photoUrlLarge: String?
    var photoUrlSmall: String?
    var uuid: String
    var sourceUrl: String?
    var youtubeUrl: String?
    
    init(cuisine: String, name: String, photoUrlLarge: String? = nil, photoUrlSmall: String? = nil, uuid: String, sourceUrl: String? = nil, youtubeUrl: String? = nil) {
        self.cuisine = cuisine
        self.name = name
        self.photoUrlLarge = photoUrlLarge
        self.photoUrlSmall = photoUrlSmall
        self.uuid = uuid
        self.sourceUrl = sourceUrl
        self.youtubeUrl = youtubeUrl
    }
}

#warning("Move this to networking package")
struct RecipeDTO: Codable {
    var cuisine: String
    var name: String
    var photoUrlLarge: String?
    var photoUrlSmall: String?
    var uuid: String
    var sourceUrl: String?
    var youtubeUrl: String?
}

struct RecipeResponse: Codable {
    let recipes: [RecipeDTO]
}
