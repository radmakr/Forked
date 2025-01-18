//
//  NetworkingEnvironment.swift
//  ForkedNetworking
//
//  Created by Thomas Rademaker on 1/18/25.
//

@NetworkingActor
class NetworkingEnvironment {
    static var current: NetworkingEnvironment = .init()
    
    var baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/"
    let routerDelegate = NetworkingRouterDelegate()
    
    private init() {}
    
    func setup() {
        // NO-OP
    }
}

