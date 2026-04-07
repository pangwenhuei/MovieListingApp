//
//  HomeViewModel.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 06/04/2026.
//


import Foundation
 
@Observable
@MainActor
class HomeViewModel {
 
    var populars: [Movie] = []
    var topRatedMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
 
    private(set) var currentPage = 1
    private(set) var totalPages = 1
    private(set) var isLoadingMore = false
    var hasMorePages: Bool { currentPage < totalPages }
 
    private let apiManager = APIManager()
 
    func loadMovies() async {
        currentPage = 1
        totalPages = 1
        // Load popular first so totalPages is set before ProgressView renders
        await loadPopularMovies(page: 1)
        // Then load the rest concurrently
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadTopRatedMovies() }
            group.addTask { await self.loadUpcomingMovies() }
        }
    }
 
    func loadMoreIfNeeded() async {
        guard !isLoadingMore, hasMorePages else { return }
        isLoadingMore = true
        let nextPage = currentPage + 1
        do {
            let response: MovieResponseModel = try await apiManager.request(
                type: MovieEndPoint.popular,
                page: nextPage
            )
            let existingIDs = Set(populars.compactMap(\.id))
            let newMovies = response.results.filter { !existingIDs.contains($0.id ?? -1) }
            populars += newMovies
            currentPage = nextPage
            totalPages = response.totalPages ?? totalPages
        } catch {
            print("loadMore error:", error)
        }
        isLoadingMore = false
    }
 
    private func loadPopularMovies(page: Int) async {
        do {
            let response: MovieResponseModel = try await apiManager.request(
                type: MovieEndPoint.popular,
                page: page
            )
            populars = response.results
            totalPages = response.totalPages ?? 1
        } catch {
            print("loadPopular error:", error)
        }
    }
 
    private func loadTopRatedMovies() async {
        do {
            let response: MovieResponseModel = try await apiManager.request(type: MovieEndPoint.topRated)
            topRatedMovies = response.results
        } catch {
            print("loadTopRated error:", error)
        }
    }
 
    private func loadUpcomingMovies() async {
        do {
            let response: MovieResponseModel = try await apiManager.request(type: MovieEndPoint.upcoming)
            upcomingMovies = response.results
        } catch {
            print("loadUpcoming error:", error)
        }
    }
}
