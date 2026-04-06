//
//  HomeRowView.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 06/04/2026.
//


import SwiftUI

struct HomeRowView: View {
    let movie: Movie

    var body: some View {
        LazyHStack {
            AsyncImage(url: movie.posterPath?.imageURL, scale: 1.1, content: { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .clipped()
                case .failure(_):
                    Image(systemName: "film")
                        .frame(width: 120, height: 150)
                case .empty:
                    ProgressView()
                        .frame(width: 120, height: 150)
                @unknown default:
                    EmptyView()
                }
            })
            LazyVStack {
                Text(movie.title ?? "")
                    .font(.headline)
                    .lineLimit(2)
                    .frame(width: 130)
                    .multilineTextAlignment(.center)
                Spacer()
                Text(movie.releaseDate ?? "")
                    .font(.headline)
                    .lineLimit(2)
                    .frame(width: 130)
                    .multilineTextAlignment(.center)
            }
        }
    }

}

#Preview {
    HomeRowView(movie: .dummy)
}
