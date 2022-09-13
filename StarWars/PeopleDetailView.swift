//
//  PeopleDetailView.swift
//  StarWars
//
//  Created by Vikram Kriplaney on 13.09.22.
//

import SwiftUI

struct PeopleDetailView: View {
    let people: People

    var body: some View {
        List {
            Section {
                DetailItem(label: "Gender", value: people.gender)
                DetailItem(label: "Mass", value: people.mass)
                DetailItem(label: "Birth Year", value: people.birthYear)
                DetailItem(label: "Eye Color", value: people.eyeColor)
                DetailItem(label: "Skin Color", value: people.skinColor)
            }
        }
        .navigationTitle(people.name)
    }
}

struct DetailItem: View {
    let label: LocalizedStringKey
    let value: String?

    var body: some View {
        if let value = value {
            HStack {
                Text(label)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(value)
            }
        }
    }
}

struct PeopleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PeopleDetailView(people: People(
                name: "Sample Skywalker",
                height: "1",
                mass: "1",
                hairColor: "Blond",
                skinColor: "White",
                eyeColor: "Green",
                birthYear: "1",
                gender: "Male",
                homeworld: "://",
                films: [],
                species: [],
                vehicles: [],
                starships: [],
                created: "",
                edited: "",
                url: "://"
            ))
        }
    }
}
