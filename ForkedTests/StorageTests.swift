//
//  StorageTests.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/19/25.
//

import Testing
import Foundation
@testable import Forked

@Suite("Storage Tests")
struct StorageTests {
    @Test("Storage URL Generation")
    func storageURLGenerationTests() async throws {
        // Test documents directory URL generation
        let documentsURL = try Storage.getURL(for: .documents)
        #expect(documentsURL.pathComponents.contains("Documents"))
        
        // Test caches directory URL generation
        let cachesURL = try Storage.getURL(for: .caches)
        #expect(cachesURL.pathComponents.contains("Caches"))
        
        // Test file URL generation
        let fileURL = Storage.url(for: "test.txt", in: .documents)
        #expect(fileURL?.lastPathComponent == "test.txt")
    }
    
    @Test("Storage Directory Clear")
    func storageClearTests() async throws {
        let testFiles = ["test1.txt", "test2.txt", "test3.txt"]
        let testData = "Test Data".data(using: .utf8)!
        
        // Store multiple test files
        for fileName in testFiles {
            try Storage.store(testData, to: .caches, as: fileName)
        }
        
        // Verify files exist
        for fileName in testFiles {
            #expect(Storage.fileExists(fileName, in: .caches))
        }
        
        // Clear directory
        try Storage.clear(.caches)
        
        // Verify files are removed
        for fileName in testFiles {
            #expect(!Storage.fileExists(fileName, in: .caches))
        }
    }
    
    @Test("Storage File Overwrite Prevention")
    func storageOverwritePreventionTests() async throws {
        let fileName = "overwrite_test.txt"
        let originalData = "Original".data(using: .utf8)!
        let newData = "New".data(using: .utf8)!
        
        // Store original file
        try Storage.store(originalData, to: .documents, as: fileName)
        #expect(Storage.fileExists(fileName, in: .documents))
        
        // Attempt to store new file with same name
        try Storage.store(newData, to: .documents, as: fileName)
        
        // Verify original file still exists and wasn't overwritten
        if let url = Storage.url(for: fileName, in: .documents),
           let storedData = try? Data(contentsOf: url),
           let storedString = String(data: storedData, encoding: .utf8) {
            #expect(storedString == "Original")
        }
        
        // Clean up
        try Storage.remove(fileName, from: .documents)
    }
}
