//
//  MovieResponceModel.swift
//  MovieToGo
//
//  Created by DimMac on 19.09.2024.
//

import Foundation

struct MoviesResponce: Decodable {
    let page: Int
    let results: [MovieResponceModel]
    let totalPages: Int
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case results
    }
}

extension MoviesResponce {
    struct MovieResponceModel: Decodable {
        let originalTitle: String
        let overview: String
        let posterPath: String
        let releaseDate: String
        let backdropPath: String
        let voteAverage: Double
        
        private enum CodingKeys: String, CodingKey {
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case originalTitle = "original_title"
            case overview
            case backdropPath = "backdrop_path"
            case voteAverage = "vote_average"
        }
    }
}

// MARK: Mapping to entity model

extension MoviesResponce {
    func modelMap() -> [Movie] {
        var movies: [Movie] = []
        print("Total pages is \(self.totalPages), current page is \(self.page)")
        results.forEach { result in
            let movie = Movie(name: result.originalTitle, description: result.overview, releaseDate: result.releaseDate, posterPath: result.posterPath, backdropPath: result.backdropPath, voteAverage: result.voteAverage)
            movies.append(movie)
        }
        return movies
    }
}
