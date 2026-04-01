//
//  NetworkError.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 01/04/2026.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case decodingError
    case invalidResponse
}
