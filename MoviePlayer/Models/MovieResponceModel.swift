//
//  MovieResponceModel.swift
//  MovieToGo
//
//  Created by DimMac on 19.09.2024.
//

import Foundation

struct MoviesResponce: Decodable {
    let results: [MovieResponceModel]
}

extension MoviesResponce {
    struct MovieResponceModel: Decodable {
        let originalTitle: String
        let overview: String
        let posterPath: String
        let releaseDate: String
        
        private enum CodingKeys: String, CodingKey {
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case originalTitle = "original_title"
            case overview
        }
    }
}

// MARK: Mapping to entity model

extension MoviesResponce {
    func modelMap() -> [Movie] {
        var movies: [Movie] = []
        results.forEach { result in
            let movie = Movie(name: result.originalTitle, description: result.overview, releaseDate: result.releaseDate, posterPath: result.posterPath)
            movies.append(movie)
        }
        return movies
    }
}
