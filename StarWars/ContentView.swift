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
                        let (data, _) = try await URLSession.shared
                            .data(from: URL(string: "https://swapi.dev/api/people/1/")!)
                        people = try JSONDecoder().decode(People.self, from: data)
                    } catch {
                        print(error)
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
