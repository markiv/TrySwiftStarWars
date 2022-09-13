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
                        NavigationLink(destination: PeopleDetailView(people: people)) {
                            Text(people.name)
                        }
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
    class ViewModel: ObservableObject {
        @MainActor @Published public private(set) var people = [People]()

        nonisolated func fetchAllPages() async {
            do {
                var people = [People]()
                var url: URL? = "https://swapi.dev/api/people"
                while url != nil {
                    print("Fetching", url!)
                    let page = try await PeoplePage(from: url!)
                    people += page.results
                    url = page.next
                }
                let temp = people // to avoid capturing the mutable array
                Task { @MainActor in
                    self.people = temp
                }
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
