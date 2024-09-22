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
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: String
}

extension Movie {
    static let mockMovie = Movie(name: "Saving Bikini Bottom: The Sandy Cheeks Movie", description: "When Bikini Bottom is scooped from the ocean, scientific squirrel Sandy Cheeks and her pal SpongeBob SquarePants saddle up for Texas to save their town.", releaseDate: "2024-08-01", posterPath: "", backdropPath: "", voteAverage: "6.08")
}
