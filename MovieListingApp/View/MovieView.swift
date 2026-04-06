//
//  MovieView.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 06/04/2026.
//


import SwiftUI

struct MovieView: View {

    var title: String
    var movies: [Movie]

    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            popularView
        }
    }

    var popularView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .center) {
                ForEach(movies) { movie in
                    HomeRowView(movie: movie)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    MovieView(title: "Populars", movies: [.dummy])
}
