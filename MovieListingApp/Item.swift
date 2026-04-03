//
//  Item.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 01/04/2026.
//

import Foundation
import SwiftData

// plain decodable struct for networking
struct MovieResponse: Decodable {
    var results: [MovieDTO]
}

struct MovieDTO: Decodable {
    var title: String?
    var releaseDate: String?
    var posterPath: String?
    
    init(title: String? = nil, releaseDate: String? = nil, posterPath: String? = nil) {
        self.title = title
        self.releaseDate = releaseDate
        self.posterPath = posterPath
    }
}

//@Model
class Movie: Identifiable, Decodable { // Hashable,
    
    @Attribute(.unique) var id: String?
    var title:String?
    var releaseDate:String?
    var posterPath:String?
    
    init(id: String? = nil, title: String? = nil, releaseDate: String? = nil, posterPath: String? = nil) {
        self.id = id == nil ? UUID().uuidString : id
        self.title = title
        self.releaseDate = releaseDate
        self.posterPath = posterPath
    }
    
    // Convenience init from DTO
    convenience init(from dto: MovieDTO) {
        self.init(title: dto.title, releaseDate: dto.releaseDate, posterPath: dto.posterPath)
    }
    
    
    enum CodingKeys: CodingKey {
        case title
        case releaseDate
        case posterPath
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    }
    
}
