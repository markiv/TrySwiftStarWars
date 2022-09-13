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
