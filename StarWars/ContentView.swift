//
//  ContentView.swift
//  StarWars
//
//  Created by Vikram Kriplaney on 13.09.22.
//

import SwiftUI

struct ContentView: View {
    @State private var people: People?

    var body: some View {
        if let people {
            List {
                Text(people.name)
            }
        } else {
            ProgressView("Loading...")
                .task {
                    do {
                        people = try await People(from: URL(string: "https://swapi.dev/api/people/1/")!)
                    } catch {
                        print(error)
                    }
                }
        }
    }
}

extension Decodable {
    init(from request: URLRequest) async throws {
        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
            throw URLError(.badServerResponse)
        }
        self = try JSONDecoder().decode(Self.self, from: data)
    }

    init(from url: URL) async throws {
        try await self.init(from: URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
