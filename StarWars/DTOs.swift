//
//  DTOs.swift
//  StarWars
//
//  Created by Vikram Kriplaney on 13.09.22.
//

import Foundation

// See https://swapi.dev/api/people/1/
struct People: Decodable {
    let name: String
    let height, mass, hairColor: String?
    let skinColor, eyeColor, birthYear, gender: String?
    let homeworld: URL
    let films, species, vehicles, starships: [URL]
    let created, edited: String
    let url: URL
}

// See https://swapi.dev/api/people/
struct PeoplePage: Decodable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [People]
}

// See https://swapi.dev/api/films/1/
struct Film: Decodable {
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
