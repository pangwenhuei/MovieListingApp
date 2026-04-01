//
//  Item.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 01/04/2026.
//

import Foundation
import SwiftData

struct Item: Decodable {
    var results:[Movie] = []
}

@Model
class Movie: Decodable {
    var title:String?
    var releaseDate:String?
    var posterPath:String?
    
    init(title: String? = nil, releaseDate: String? = nil, posterPath: String? = nil) {
        self.title = title
        self.releaseDate = releaseDate
        self.posterPath = posterPath
    }
    
    enum CodingKeys: CodingKey {
        case title
        case releaseDate
        case posterPath
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    }
}
