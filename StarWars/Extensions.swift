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
