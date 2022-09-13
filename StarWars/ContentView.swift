//
//  ContentView.swift
//  StarWars
//
//  Created by Vikram Kriplaney on 13.09.22.
//

import SwiftUI

struct ContentView: View {
    @State private var page: PeoplePage?

    var body: some View {
        if let page {
            List {
                ForEach(page.results) { people in
                    Text(people.name)
                }
            }
        } else {
            ProgressView("Loading...")
                .task {
                    do {
                        page = try await PeoplePage(from: URL(string: "https://swapi.dev/api/people")!)
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
