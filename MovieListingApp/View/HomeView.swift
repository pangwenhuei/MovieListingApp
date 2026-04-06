//
//  HomeView.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 06/04/2026.
//


import SwiftUI

struct HomeView: View {
    @State var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                headerView

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
//                        MovieView(title: "Upcomings", movies: viewModel.upcomingMovies)
                        
                        MovieView(title: "Populars", movies: viewModel.populars)

//                        MovieView(title: "Top Rated", movies: viewModel.topRatedMovies)
                    }
                }

                Spacer()
            }
            .padding()
            .ignoresSafeArea(edges: .bottom)
            .task {
                await viewModel.loadMovies()
            }
        }
    }

    var headerView: some View {
        VStack(alignment: .leading) {
            Text("Welcome back")
                .foregroundStyle(.secondary)
                .font(.caption)
            Text("Pang")
                .font(.title)
        }
    }
  
}

#Preview {
    HomeView().preferredColorScheme(.dark)
}
