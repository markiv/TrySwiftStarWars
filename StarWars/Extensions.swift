//
//  Extensions.swift
//  StarWars
//
//  Created by Vikram Kriplaney on 13.09.22.
//

import Foundation

extension Decodable {
    /// Generic asynchronous initializer for any Decodable, requesting and decoding JSON.
    init(from request: URLRequest) async throws {
        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self = try decoder.decode(Self.self, from: data)
    }

    init(from url: URL) async throws {
        // Crank up the caching to the max
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
                if let value = value {
                    results.append(value)
                }
            }
        }
        return results
    }
}

extension URLSession {
    // Backport
    @available(iOS, deprecated: 15, message: "This extension is no longer needed")
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            dataTask(with: url) { data, response, error in
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode < 400 {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: error ?? URLError(.badServerResponse))
                }
            }
            .resume()
        }
    }
}

#if DEBUG
extension Decodable {
    /// Initializes any Decodable from a JSON mock in the main bundle.
    init(mock name: String) {
        let url = Bundle.main.url(forResource: name, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self = try! decoder.decode(Self.self, from: data)
    }
}
#endif
