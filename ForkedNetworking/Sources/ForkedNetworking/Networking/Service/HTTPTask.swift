//
//  HTTPTask.swift
//  ForkedNetworking
//
//  Created by Thomas Rademaker on 1/18/25.
//

enum HTTPTask: Sendable {
    case request
    
    case requestParameters(encoding: ParameterEncoding)
    
    // case download, upload...etc
}
