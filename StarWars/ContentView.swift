//
//  ContentView.swift
//  StarWars
//
//  Created by Vikram Kriplaney on 13.09.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            if !viewModel.people.isEmpty {
                List {
                    ForEach(viewModel.people) { people in
                        Text(people.name)
                    }
                }
                .navigationTitle("Star Wars People")
            } else {
                ProgressView("Loading...")
                    .task {
                        await viewModel.fetchAllPages()
                    }
            }
        }
    }
}

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published public private(set) var people = [People]()

        func fetchAllPages() async {
            do {
                var people = [People]()
                var url: URL? = "https://swapi.dev/api/people"
                while url != nil {
                    print("Fetching", url!)
                    let page = try await PeoplePage(from: url!)
                    people += page.results
                    url = page.next
                }
                self.people = people
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
