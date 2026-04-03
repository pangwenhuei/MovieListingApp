//
//  APIClient.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 01/04/2026.
//

import Foundation

class APIClient {
    var url = "https://api.themoviedb.org/3/trending/movie/day"
    var apiAccessToken = "your_api_access_token_here"
    
    func fetchMovies() async throws -> [Movie] {
        do {
            let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
              URLQueryItem(name: "language", value: "en-US"),
              URLQueryItem(name: "page", value: "1"),
            ]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
              "accept": "application/json",
              "Authorization": "Bearer \(apiAccessToken)"
            ]

            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(MovieResponseModel.self, from: data)
            return result.results
        } catch {
            throw error
        }
        
    }
    
}
