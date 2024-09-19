//
//  MovieDetailView.swift
//  MoviePlayer
//
//  Created by DimMac on 18.09.2024.
//

import SwiftUI

struct MovieDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    var movie: Movie
    
    var body: some View {

            ScrollView {
                MovieImage(movie: movie)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        dismiss()
                    }){
                        Image("BackButton")
                    }
                    
                }
                ToolbarItem(placement: .principal) {
                
                                        Image("Logo")
                
                                }
            })
        
        
    }
}

private struct BackButton: View {
    var body: some View {
        Button("ku") {
            
        }
    }
}

private struct MovieImage: View {
    
    var movie: Movie
    
    var body: some View {
        VStack(spacing: 20){
            MoviewPreviewImage(movie: movie)
            VStack(alignment: .leading, spacing: 20) {
                Text("Description:")
                    .font(.custom("Raleway", fixedSize: 16))
                .fontWeight(.semibold)
                Text(movie.description)
                    .font(.custom("Raleway", fixedSize: 14))
                Text("Release: " + movie.releaseDate)
                    .font(.custom("Raleway", fixedSize: 14))
                    .foregroundColor(Color("MainAccentColor"))
                    .fontWeight(.semibold)
            }
           
                
        }
        .padding()
    }
}

struct MoviewPreviewImage: View {
    
    var movie: Movie
    var imageURL = "https://image.tmdb.org/t/p/w500/"
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL + movie.backdropPath)) { image in
            image
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom) {
                    HStack {
                        Text(movie.name)
                            .foregroundColor(.white)
                            .font(.custom("Raleway", fixedSize: 16))
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(movie.voteAverage))
                            .foregroundColor(.white)
                            .font(.custom("Raleway", fixedSize: 12))
                        Image("star")
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal, 12)
                    
                }
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

#Preview {
    MovieDetailView(movie: Movie(name: "Saving Bikini Bottom: The Sandy Cheeks Movie", description: "When Bikini Bottom is scooped from the ocean, scientific squirrel Sandy Cheeks and her pal SpongeBob SquarePants saddle up for Texas to save their town.", releaseDate: "2024-08-01", posterPath: "", backdropPath: "", voteAverage: 6.08))
}
