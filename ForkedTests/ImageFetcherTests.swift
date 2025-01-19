//
//  ImageFetcherTests.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/19/25.
//

import Testing
import Foundation
@testable import Forked

@Suite("ImageFetcher Tests")
struct ImageFetcherTests {
    @Test("URL normalization removes forward slashes")
    func urlNormalization() {
        let url = "https://example.com/image/test.jpg"
        let normalized = ImageFetcher.normalizeURL(url)
        
        #expect(!normalized.contains("/"))
        #expect(normalized == "https:example.comimagetest.jpg")
    }
    
    @Test("Fetching same image URL doesn't create duplicate requests")
    func noDuplicateRequests() async throws {
        let fetcher = ImageFetcher()
        let url = "https://example.com/test.jpg"
        
        await fetcher.fetchImage(from: url)
        await fetcher.fetchImage(from: url)
        
        let mirror = Mirror(reflecting: fetcher)
        let requests = try #require(
            mirror.children.first(where: { $0.label == "inProgressRequests" })?.value as? [String: Task<(), any Error>]
        )
        
        #expect(requests.count == 1)
    }
    
    @Test("Cancelling prefetch removes request and cancels task")
    func cancelPrefetch() async throws {
        let fetcher = ImageFetcher()
        let url = "https://example.com/test.jpg"
        
        await fetcher.fetchImage(from: url)
        await fetcher.cancelPrefetch(for: url)
        
        let mirror = Mirror(reflecting: fetcher)
        let requests = try #require(
            mirror.children.first(where: { $0.label == "inProgressRequests" })?.value as? [String: Task<(), any Error>]
        )
        
        #expect(requests.isEmpty)
    }
    
    @Test("Fetching image with different priorities", arguments: [TaskPriority.high, TaskPriority.medium, TaskPriority.low, TaskPriority.background])
    func fetchWithPriority(_ priority: TaskPriority) async throws {
        let fetcher = ImageFetcher()
        let url = "https://example.com/test.jpg"
        
        await fetcher.fetchImage(from: url, priority: priority)
        
        let mirror = Mirror(reflecting: fetcher)
        let requests = try #require(
            mirror.children.first(where: { $0.label == "inProgressRequests" })?.value as? [String: Task<(), any Error>]
        )
        
        #expect(!requests.isEmpty)
    }
    
    // MARK: - Integration Tests
    
    @Test("Successfully fetches and caches image data")
    func successfulImageFetch() async throws {
        let fetcher = ImageFetcher()
        let url = "https://example.com/test.jpg"
        
        await fetcher.fetchImage(from: url)
    }
}

// MARK: - Test Helpers

actor MockStorage {
    static var storedData: [String: Data] = [:]
    
    static func store(_ data: Data, to directory: Storage.Directory, as fileName: String) throws {
        storedData[fileName] = data
    }
    
    static func clear(_ directory: Storage.Directory) throws {
        storedData.removeAll()
    }
}
