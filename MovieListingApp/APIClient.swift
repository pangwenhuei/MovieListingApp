//
//  APIClient.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 01/04/2026.
//

import Foundation

protocol FetchMovie {
    func fetchMovies() -> [Movie]
}

class APIClient {
    var url = "https://api.themoviedb.org/3/trending/movie/day"
    
    func fetchMovies() async throws -> [Movie] {
        do {
            //setup url request
            guard let request = URLRequest(url: URL(string: url)!) as URLRequest? else {
                throw APIError.invalidURL
            }
            
            //call get using urlsession
            let task = URLSession.shared.dataTask(with: request)
            task.resume()
            
            guard let response = task.response as? HTTPURLResponse, response.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            //decode the response
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let data = response.value(forKey: "results") as? Data ?? Data()
            let result = try decoder.decode([Movie].self, from: data)
            //return movie
            return result
        }
        
    }
    
}

/*
 --request GET \
     --url https://api.themoviedb.org/3/trending/movie/day \
     --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlOThkMTVjZjBlZmU3NGZjNWUxN2FiODVlZWNiZDRmYyIsIm5iZiI6MTc3NTAxNzk1My41NzYsInN1YiI6IjY5Y2M5ZmUxZGFkZDUxZGY4MWM5ZDQ0MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.1UXZUr3qUwngQBBCkoIMQFmrEEMKp9Zmqti_RCFph7k' \
     --header 'accept: application/json'
 */
