//
//  Item.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 01/04/2026.
//

import Foundation
import SwiftData

struct MovieResponseModel: Codable {
    let results: [Movie]
    let totalPages: Int?
}
 
struct Movie: Codable, Identifiable, Hashable {
    let id: Int?
    let posterPath, releaseDate, title: String?
 
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath
        case releaseDate
        case title
    }
}
 
extension Movie {
 
    static var dummy: Movie {
        .init(
            id: 693134,
            posterPath: "/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg",
            releaseDate: "2024-02-27",
            title: "Dune: Part Two",
        )
    }
}
