//
//  MovieCard.swift
//  MovieToGo
//
//  Created by DimMac on 19.09.2024.
//

import SwiftUI

struct MovieCard: View {
    
    var movie: Movie
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
               
                    MovieImage(movie: movie)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(movie.name)
                        .font(.custom("Raleway", fixedSize: 14))
                        .fontWeight(.bold)
                    Text(movie.description)
                        .font(.custom("Raleway", fixedSize: 14))
                        .foregroundColor(Color("DescriptionTextColor"))
                    Text(movie.releaseDate)
                        .font(.custom("Raleway", fixedSize: 14))
                        .foregroundColor(Color("MainAccentColor"))
                        .fontWeight(.bold)
                }
            }
            .onTapGesture(perform: {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
            })
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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
            .frame(width: 128, height: 188)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
        }
    }
}



#Preview {
    MovieCard(movie: Movie(name: "Saving Bikini Bottom: The Sandy Cheeks Movie", description: "When Bikini Bottom is scooped from the ocean, scientific squirrel Sandy Cheeks and her pal SpongeBob SquarePants saddle up for Texas to save their town.", releaseDate: "2024-08-01", posterPath: ""))
}
