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
                    LazyVStack(spacing: 8) {
                        Text("Populars")
                            .font(.title2)
                            .fontWeight(.bold)

                        ForEach(viewModel.populars) { movie in
                            HomeRowView(movie: movie)
                                .foregroundColor(.primary)
                        }

                        // Loading more indicator
                        if viewModel.isLoadingMore {
                            HStack(spacing: 8) {
                                ProgressView()
                                Text("Loading more...")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()

                        // Invisible scroll trigger
                        } else if viewModel.hasMorePages {
                            Color.clear
                                .frame(height: 1)
                                .onAppear {
                                    Task { await viewModel.loadMoreIfNeeded() }
                                }

                        // End of list
                        } else if !viewModel.populars.isEmpty {
                            VStack(spacing: 4) {
                                Image(systemName: "checkmark.circle")
                                    .foregroundStyle(.secondary)
                                Text("You've reached the end")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    }
                    .padding()
                }
            }
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView().preferredColorScheme(.dark)
}
