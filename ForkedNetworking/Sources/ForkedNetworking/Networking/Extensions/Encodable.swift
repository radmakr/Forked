//
//  Encodable.swift
//  ForkedNetworking
//
//  Created by Thomas Rademaker on 1/18/25.
//

import Foundation

extension Encodable {
    func toJSONData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}
