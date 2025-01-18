//
//  Networking.swift
//  ForkedNetworking
//
//  Created by Thomas Rademaker on 1/18/25.
//

import Foundation

extension JSONDecoder {
    static var forkedDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }
}

extension JSONEncoder {
    static var forkedEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        return encoder
    }
}

@NetworkingActor
class NetworkingRouterDelegate: NetworkRouterDelegate {
    func shouldRetry(error: any Error, attempts: Int) async throws -> Bool {
        false
    }
    
    func intercept(_ request: inout URLRequest) async {
        // NO-OP
    }
}
