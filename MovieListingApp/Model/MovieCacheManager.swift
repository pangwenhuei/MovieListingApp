//
//  MovieCacheManager.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 07/04/2026.
//


import Foundation

final class MovieCacheManager {

    static let shared = MovieCacheManager()
    private let defaults = UserDefaults.standard

    // TTL per endpoint — TMDB data doesn't change by the minute
    private enum TTL {
        static let popular:  TimeInterval = 5  * 60       // 5 minutes
        static let topRated: TimeInterval = 60 * 60       // 1 hour
        static let upcoming: TimeInterval = 12 * 60 * 60  // 12 hours
    }

    private struct CacheEntry: Codable {
        let data: Data
        let cachedAt: Date
    }

    // MARK: - Public API

    func cachedMovies(for key: CacheKey, ttl: TimeInterval) -> [Movie]? {
        guard
            let raw = defaults.data(forKey: key.rawValue),
            let entry = try? JSONDecoder().decode(CacheEntry.self, from: raw),
            Date().timeIntervalSince(entry.cachedAt) < ttl
        else { return nil }

        return try? JSONDecoder().decode([Movie].self, from: entry.data)
    }

    func cache(_ movies: [Movie], for key: CacheKey) {
        guard
            let moviesData = try? JSONEncoder().encode(movies),
            let entryData  = try? JSONEncoder().encode(CacheEntry(data: moviesData, cachedAt: Date()))
        else { return }
        defaults.set(entryData, forKey: key.rawValue)
    }

    func clearAll() {
        CacheKey.allCases.forEach { defaults.removeObject(forKey: $0.rawValue) }
    }

    // MARK: - Keys

    enum CacheKey: String, CaseIterable {
        case popular  = "cache.movies.popular"
        case topRated = "cache.movies.topRated"
        case upcoming = "cache.movies.upcoming"
    }

    // Convenience TTL accessors
    static var popularTTL:  TimeInterval { TTL.popular }
    static var topRatedTTL: TimeInterval { TTL.topRated }
    static var upcomingTTL: TimeInterval { TTL.upcoming }
}