//
//  DTOs.swift
//  StarWars
//
//  Created by Vikram Kriplaney on 13.09.22.
//

import Foundation

// https://swapi.dev/api/people/1/
struct People: Decodable {
    let name: String
    let height, mass, hairColor: String?
    let skinColor, eyeColor, birthYear, gender: String?
    let homeworld: URL
    let films, species, vehicles, starships: [URL]
    let created, edited: String
    let url: URL
}

struct PeoplePage: Decodable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [People]
}

struct Film: Codable {
    let title: String
    let created, director, edited: String
    let episodeId: Int
    let openingCrawl: String
    let producer, releaseDate: String
    let characters: [URL]
    let planets: [URL]
    let species, starships: [URL]
    let vehicles: [URL]
    let url: URL
}

extension People: Identifiable {
    var id: URL { url }
}

extension Film: Identifiable {
    var id: URL { url }
}

extension Decodable {
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
        try await self.init(from: URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(string: value)!
    }
}
