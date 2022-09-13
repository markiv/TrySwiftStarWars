//
//  Extensions.swift
//  StarWars
//
//  Created by Vikram Kriplaney on 13.09.22.
//

import Foundation

extension JSONDecoder {
    static let snakeCaseDecoder: JSONDecoder = {
        let this = JSONDecoder()
        this.keyDecodingStrategy = .convertFromSnakeCase
        return this
    }()
}

extension Decodable {
    /// Generic asynchronous initializer for any Decodable, requesting and decoding JSON.
    init(from request: URLRequest) async throws {
        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
            throw URLError(.badServerResponse)
        }
        self = try JSONDecoder.snakeCaseDecoder.decode(Self.self, from: data)
    }

    init(from url: URL) async throws {
        // Use cached responses as much as possible, to avoid hitting API rate limits.
        try await self.init(from: URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
    }
}

extension URL: ExpressibleByStringLiteral {
    /// Allows string literals to be used as URLs
    public init(stringLiteral value: StringLiteralType) {
        self.init(string: value)!
    }
}

extension Collection where Element == URL {
    /// Concurrently gets a collection of a generic Decodable type from a collection of URLs.
    /// This version will fail if any sub-task fails.
    func getAll<T: Decodable>() async throws -> [T] {
        var results = [T]()
        try await withThrowingTaskGroup(of: T.self) { group in
            forEach { url in
                group.addTask {
                    try await T(from: url)
                }
            }
            for try await value in group {
                results.append(value)
            }
        }
        return results
    }

    /// Concurrently gets a collection of a generic Decodable type from a collection of URLs.
    /// This version will ignore any failures, returning as many elements as possible.
    func getAllPossible<T: Decodable>() async -> [T] {
        var results = [T]()
        await withTaskGroup(of: T?.self) { group in
            forEach { url in
                group.addTask {
                    try? await T(from: url)
                }
            }
            for await value in group {
                if let value {
                    results.append(value)
                }
            }
        }
        return results
    }
}

extension URLSession {
    /// A backport of `data(for request: ...) async...` for older platform versions.
    @available(iOS, deprecated: 15.0, message: "This backport is no longer needed. Use URLSession's built-in method.")
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            dataTask(with: url) { data, response, error in
                if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
                    continuation.resume(throwing: URLError(.badServerResponse))
                } else if let data, let response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: error ?? URLError(.unknown))
                }
            }
            .resume() // Start the URLSessionTask
        }
    }
}

#if DEBUG
extension Decodable {
    /// Initializes any Decodable from a JSON mock in the main bundle.
    init(mock name: String) {
        let url = Bundle.main.url(forResource: name, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        self = try! JSONDecoder.snakeCaseDecoder.decode(Self.self, from: data)
    }
}
#endif
