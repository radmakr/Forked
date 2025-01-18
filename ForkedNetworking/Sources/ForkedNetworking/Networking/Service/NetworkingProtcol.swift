//
//  NetworkingProtcol.swift
//  ForkedNetworking
//
//  Created by Thomas Rademaker on 1/18/25.
//

@preconcurrency import Foundation

@NetworkingActor
protocol Networking {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: Networking { }
