//
//  MovieCard.swift
//  MovieToGo
//
//  Created by DimMac on 19.09.2024.
//

import SwiftUI

struct MovieCard: View {
    
    @State var image: Image?
    var movie: Movie
    var viewModel: MoviesViewModel
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
               
                    MovieImage(image: image)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(movie.name)
                        .font(.custom("Raleway", fixedSize: 14))
                        .fontWeight(.bold)
                    Text(movie.description)
                        .font(.custom("Raleway", fixedSize: 12))
                        .foregroundColor(Color.description)
                    Text("Release: \(movie.releaseDate)")
                        .font(.custom("Raleway", fixedSize: 12))
                        .foregroundColor(Color.accent)
                        .fontWeight(.semibold)
                }
            }
            .onAppear {
                viewModel.loadImage(imagePath: movie.posterPath) { data in
                    guard let image = UIImage(data: data) else {return}
                    self.image = Image(uiImage: image)
                }
            }
        }
        
        
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct MovieImage: View {
    
    var image: Image?
    
    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(width: 128, height: 188)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}



#Preview {
    MovieCard(movie: Movie(name: "Saving Bikini Bottom: The Sandy Cheeks Movie", description: "When Bikini Bottom is scooped from the ocean, scientific squirrel Sandy Cheeks and her pal SpongeBob SquarePants saddle up for Texas to save their town.", releaseDate: "2024-08-01", posterPath: "", backdropPath: "", voteAverage: "6.08"), viewModel: MoviesViewModel())
}
