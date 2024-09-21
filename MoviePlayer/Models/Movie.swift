//
//  Movie.swift
//  MovieToGo
//
//  Created by DimMac on 18.09.2024.
//

import Foundation

struct Movie: Identifiable, Codable {
    var id = UUID()
    let name: String
    let description: String
    let releaseDate: String
    let posterPath: String
    let backdropPath: String
    let voteAverage: String
}

extension Movie {
    static let allMovies: [Movie] = []
}
