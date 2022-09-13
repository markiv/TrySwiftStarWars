//
//  PeopleDetailView.swift
//  StarWars
//
//  Created by Vikram Kriplaney on 13.09.22.
//

import SwiftUI

struct PeopleDetailView: View {
    let people: People
    @State private var films: [Film]?

    var body: some View {
        List {
            Section {
                ListDetailItem(label: "Name", value: people.name)
                ListDetailItem(label: "Birth", value: people.birthYear)
                ListDetailItem(label: "Gender", value: people.gender)
                ListDetailItem(label: "Height", value: people.height)
                ListDetailItem(label: "Mass", value: people.mass)
                ListDetailItem(label: "Eye Color", value: people.eyeColor)
                ListDetailItem(label: "Hair Color", value: people.hairColor)
                ListDetailItem(label: "Skin Color", value: people.skinColor)
            }
            if let films, !films.isEmpty {
                Section("Films") {
                    ForEach(films) { film in
                        NavigationLink(film.title) {
                            FilmDetailView(film: film)
                        }
                    }
                }
            }
        }
        .navigationTitle(people.name)
        .task {
            films = await people.films.getAllPossible()
        }
    }
}

#if DEBUG
struct PeopleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PeopleDetailView(people: People(mock: "people1"))
        }
    }
}
#endif
