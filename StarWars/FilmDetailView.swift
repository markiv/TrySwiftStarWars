//
//  FilmDetailView.swift
//  StarWars
//
//  Created by Vikram Kriplaney on 13.09.22.
//

import SwiftUI

struct FilmDetailView: View {
    let film: Film

    var body: some View {
        List {
            Section {
                ListDetailItem(label: "Episode", value: film.episodeId)
                ListDetailItem(label: "Title", value: film.title)
                ListDetailItem(label: "Director", value: film.director)
                ListDetailItem(label: "Producer", value: film.producer)
                ListDetailItem(label: "Released", value: film.releaseDate)
            }
            Section {
                NavigationLink {
                    Text("Under Construction")
                } label: {
                    Text("Opening Crawl")
                }
            }
        }
        .navigationTitle(film.title)
    }
}

#if DEBUG
struct FilmDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FilmDetailView(film: Film(mock: "film1"))
        }
    }
}
#endif
