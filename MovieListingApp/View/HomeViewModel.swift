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

    // MARK: - Raw unfiltered backing store — pagination always appends to this
    private var allPopulars: [Movie] = []

    // MARK: - Filtered output
    var populars: [Movie] {
        applyFilters(to: allPopulars)
    }

    var topRatedMovies: [Movie] = []
    var upcomingMovies: [Movie] = []

    // MARK: - Pagination
    private(set) var currentPage = 1
    private(set) var totalPages = 1
    private(set) var isLoadingMore = false
    var hasMorePages: Bool { currentPage < totalPages }

    // MARK: - Filters
    var searchTitle: String = ""
    var selectedYear: Int? = nil
    var startDate: Date? = nil
    var endDate: Date? = nil

    //extracts unique release years from fetched data to populate the year picker dynamically
    var allYears: [Int] {
        allPopulars.compactMap { movie -> Int? in
            guard let dateStr = movie.releaseDate else { return nil }
            return Int(dateStr.prefix(4))
        }
        .uniqued()
    }

    var isFiltering: Bool {
        !searchTitle.isEmpty || selectedYear != nil || startDate != nil || endDate != nil
    }

    private let apiManager = APIManager()

    // MARK: - Filter logic
    private func applyFilters(to movies: [Movie]) -> [Movie] {
        movies.filter { movie in
            // Title filter
            let titleMatch: Bool = {
                guard !searchTitle.isEmpty else { return true }
                return movie.title?.localizedCaseInsensitiveContains(searchTitle) ?? false
            }()

            // Release year filter
            let yearMatch: Bool = {
                guard let year = selectedYear else { return true }
                guard let dateStr = movie.releaseDate,
                      let movieYear = Int(dateStr.prefix(4)) else { return false }
                return movieYear == year
            }()

            // Release date range filter
            let dateMatch: Bool = {
                guard startDate != nil || endDate != nil else { return true }
                guard let dateStr = movie.releaseDate,
                      let movieDate = parseDate(dateStr) else { return false }
                if let start = startDate, movieDate < start { return false }
                if let end = endDate, movieDate > end { return false }
                return true
            }()

            return titleMatch && yearMatch && dateMatch
        }
    }

    private func parseDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }

    //clears all three filter states at once
    func resetFilters() {
        searchTitle = ""
        selectedYear = nil
        startDate = nil
        endDate = nil
    }

    // MARK: - Data loading
    func loadMovies() async {
        currentPage = 1
        totalPages = 1
        allPopulars = []
        await loadPopularMovies(page: 1)
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
            let existingIDs = Set(allPopulars.compactMap(\.id))
            let newMovies = response.results.filter { !existingIDs.contains($0.id ?? -1) }
            allPopulars += newMovies
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
            allPopulars = response.results
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

// MARK: - Array helper
private extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
