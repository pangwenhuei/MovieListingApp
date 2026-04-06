//
//  NetworkError.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 01/04/2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case network(_ error: Error?)
    case invalidError
}
