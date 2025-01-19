import Testing
import Foundation
@testable import ForkedNetworking

@Test("Recipe Service Tests")
func recipeServiceTests() async throws {
    // Test successful recipe fetch
    let service = await RecipeService()
    let response = try await service.getAll()
    #expect(!response.recipes.isEmpty)
    
    // Test empty response
    let emptyResponse = try await service.getEmpty()
    #expect(emptyResponse.recipes.isEmpty)
    
    // Test malformed response handling
    let malformedResponse = try await service.getMalformed()
    #expect(malformedResponse.recipes.contains(where: { $0 == nil }))
}

@Test("URL Parameter Encoding Tests")
func urlParameterEncodingTests() throws {
    var urlRequest = URLRequest(url: URL(string: "https://api.test.com")!)
    let parameters: Parameters = [
        "name": "test",
        "page": 1
    ]
    
    let encoder = URLParameterEncoder()
    try encoder.encode(urlRequest: &urlRequest, with: parameters)
    
    let encodedURL = urlRequest.url?.absoluteString ?? ""
    #expect(encodedURL.contains("name=test"))
    #expect(encodedURL.contains("page=1"))
}

@Test("JSON Parameter Encoding Tests")
func jsonParameterEncodingTests() throws {
    var urlRequest = URLRequest(url: URL(string: "https://api.test.com")!)
    let parameters: Parameters = [
        "name": "test",
        "count": 42
    ]
    
    let encoder = JSONParameterEncoder()
    try encoder.encode(urlRequest: &urlRequest, with: parameters)
    
    #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    
    if let httpBody = urlRequest.httpBody,
       let jsonObject = try? JSONSerialization.jsonObject(with: httpBody) as? [String: Any] {
        #expect(jsonObject["name"] as? String == "test")
        #expect(jsonObject["count"] as? Int == 42)
    }
}

@Test("NetworkRouter Request Building")
func networkRouterRequestBuildingTests() async throws {
    enum TestEndpoint: EndpointType {
        case test
        
        var baseURL: URL {
            get async {
                URL(string: "https://api.test.com")!
            }
        }
        
        var path: String { "/test" }
        var httpMethod: HTTPMethod { .get }
        var task: HTTPTask { .request }
        var headers: HTTPHeaders? { ["Authorization": "Bearer test"] }
    }
    
    let router = await NetworkRouter<TestEndpoint>()
    let request = try await router.buildRequest(from: .test)
    
    #expect(request.httpMethod == "GET")
    #expect(request.url?.absoluteString == "https://api.test.com/test")
    #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer test")
}

@Test("Recipe DTO Decoding")
func recipeDTODecodingTests() throws {
    let json = """
    {
        "cuisine": "Italian",
        "name": "Pasta Carbonara",
        "photo_url_large": "https://example.com/large.jpg",
        "photo_url_small": "https://example.com/small.jpg",
        "uuid": "123-456",
        "source_url": "https://example.com/recipe",
        "youtube_url": "https://youtube.com/watch"
    }
    """.data(using: .utf8)!
    
    let recipe = try JSONDecoder.forkedDecoder.decode(RecipeDTO.self, from: json)
    
    #expect(recipe.cuisine == "Italian")
    #expect(recipe.name == "Pasta Carbonara")
    #expect(recipe.photoUrlLarge == "https://example.com/large.jpg")
    #expect(recipe.photoUrlSmall == "https://example.com/small.jpg")
    #expect(recipe.uuid == "123-456")
    #expect(recipe.sourceUrl == "https://example.com/recipe")
    #expect(recipe.youtubeUrl == "https://youtube.com/watch")
}

@Test("Recipe Response Decoding")
func recipeResponseDecodingTests() throws {
    let json = """
    {
        "recipes": [
            {
                "cuisine": "Italian",
                "name": "Pasta",
                "uuid": "123"
            },
            null,
            {
                "cuisine": "Mexican",
                "name": "Tacos",
                "uuid": "456"
            }
        ]
    }
    """.data(using: .utf8)!
    
    let response = try JSONDecoder.forkedDecoder.decode(RecipeResponse.self, from: json)
    
    #expect(response.recipes.count == 3)
    #expect(response.recipes[0]?.name == "Pasta")
    #expect(response.recipes[1] == nil)
    #expect(response.recipes[2]?.name == "Tacos")
}

@Test("Status Code Tests")
func statusCodeTests() {
    #expect(StatusCode(rawValue: 200) == .ok)
    #expect(StatusCode(rawValue: 404) == .notFound)
    #expect(StatusCode(rawValue: 500) == .internalServerError)
}

@Test("Network Error Tests")
func networkErrorTests() {
    let statusCodeError = NetworkError.statusCode(.notFound, data: Data())
    #expect(statusCodeError.testNonNil())
    
    let encodingError = NetworkError.encodingFailed
    #expect(encodingError.testNonNil())
}

extension NetworkError {
    func testNonNil() -> Bool {
        switch self {
        case .encodingFailed, .missingURL, .statusCode, .noStatusCode, .noData, .tokenRefresh:
            return true
        }
    }
}
