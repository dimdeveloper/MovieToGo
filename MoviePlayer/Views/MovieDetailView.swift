//
//  MovieDetailView.swift
//  MoviePlayer
//
//  Created by DimMac on 18.09.2024.
//

import SwiftUI

struct MovieDetailView: View {
    
    var movie: Movie
    
    var body: some View {
        ScrollView {
            MovieImage(movie: movie)
        }
    }
}

private struct MovieImage: View {
    
    var movie: Movie
    var imageURL = "https://image.tmdb.org/t/p/w500/"
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageURL + movie.posterPath)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .frame(width: nil, height: 193)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
        }
    }
}

#Preview {
    MovieDetailView(movie: Movie(name: "Saving Bikini Bottom: The Sandy Cheeks Movie", description: "When Bikini Bottom is scooped from the ocean, scientific squirrel Sandy Cheeks and her pal SpongeBob SquarePants saddle up for Texas to save their town.", releaseDate: "2024-08-01", posterPath: ""))
}
