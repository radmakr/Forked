//
//  ForkedCodable.swift
//  ForkedNetworking
//
//  Created by Thomas Rademaker on 1/18/25.
//

import Foundation

protocol ForkedCodable: ForkedEncodable, ForkedDecodable, Sendable {}
protocol ForkedEncodable: Encodable, Sendable {}
protocol ForkedDecodable: Decodable, Sendable {}
