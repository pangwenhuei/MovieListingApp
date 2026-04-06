//
//  APIManager.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 03/04/2026.
//

import Foundation

final class APIManager {

    func request<T: Decodable>(type: EndPointType) async throws -> T {
        guard let url = type.url else { throw NetworkError.invalidURL }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        guard let urlComponent = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: urlComponent)
        request.httpMethod = type.method.rawValue
        request.timeoutInterval = 10

        if let body = type.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }

        request.allHTTPHeaderFields = type.headers
        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.invalidResponse }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }

    static var commonHeaders: [String: String]? {
        ["accept" : "application/json"]
    }
}
