//
//  RecipeService.swift
//  ForkedNetworking
//
//  Created by Thomas Rademaker on 1/18/25.
//

import Foundation

@NetworkingActor
public struct RecipeService: Sendable {
    private let router: NetworkRouter<RecipeAPI> = {
        let router = NetworkRouter<RecipeAPI>(decoder: .forkedDecoder)
        router.delegate = NetworkingEnvironment.current.routerDelegate
        return router
    }()
    
    public init() {}
    
    public func getAll() async throws -> RecipeResponse {
        try await router.execute(.all)
    }
    
    public func getMalformed() async throws -> RecipeResponse {
        try await router.execute(.malformed)
    }
    
    public func getEmpty() async throws -> RecipeResponse {
        try await router.execute(.empty)
    }
}

public enum RecipeAPI {
    case all
    case malformed
    case empty
    
    public var title: String {
        switch self {
        case .all: "all"
        case .malformed: "malformed"
        case .empty: "empty"
        }
    }
}

extension RecipeAPI: EndpointType {
    public var baseURL: URL {
        get async {
            let environmentURL = await NetworkingEnvironment.current.baseURL
            guard let url = URL(string: environmentURL) else { fatalError("baseURL not configured.") }
            return url
        }
    }
    
    var path: String {
        switch self {
        case .all: "recipes.json"
        case .malformed: "recipes-malformed.json"
        case .empty: "recipes-empty.json"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .all, .malformed, .empty: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .all, .malformed, .empty:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
