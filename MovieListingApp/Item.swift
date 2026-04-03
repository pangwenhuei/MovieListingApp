//
//  Item.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 01/04/2026.
//

import Foundation
import SwiftData

struct MovieResponseModel: Decodable {
    let results: [Movie]
}

struct Movie: Decodable, Identifiable, Hashable {
    let id: Int?
    let releaseDate, title, posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath
        case releaseDate
        case title
    }
}
