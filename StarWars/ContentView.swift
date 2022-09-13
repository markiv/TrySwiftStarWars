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
                        people = try await URL(string: "https://swapi.dev/api/people/1/")!.get()
                    } catch {
                        print(error)
                    }
                }
        }
    }
}

extension URL {
    func get<T: Decodable>() async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: self)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
