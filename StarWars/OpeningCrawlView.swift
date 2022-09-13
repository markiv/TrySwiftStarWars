//
//  OpeningCrawlView.swift
//  StarWars
//
//  Created by Vikram Kriplaney on 13.09.22.
//

import SwiftUI

struct OpeningCrawlView: View {
    let film: Film

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Spacer(minLength: 200)
                Text("Episode \(film.episodeId)")
                Text(film.title)
                Text(film.sanitizedOpeningCrawl)
                Spacer(minLength: 400)
            }
            .multilineTextAlignment(.center)
            .font(.title.bold())
            .foregroundColor(.yellow)
            .padding(.horizontal)
        }
        .rotation3DEffect(.degrees(45), axis: (x: 1, y: 0, z: 0), perspective: 0.5)
        .scaleEffect(y: 1.8)
        .background(.black)
        .preferredColorScheme(.dark)
        .task {
            print(film.sanitizedOpeningCrawl)
        }
    }
}

extension Film {
    var sanitizedOpeningCrawl: String {
        openingCrawl
            .replacingOccurrences(of: "\r\n\r\n", with: "\n\n")
            .replacingOccurrences(of: "\r\n", with: " ")
    }
}

#if DEBUG
struct OpeningCrawlView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningCrawlView(film: Film(mock: "film1"))
    }
}
#endif
