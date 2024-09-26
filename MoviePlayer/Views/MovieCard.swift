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
                        .font(.custom(Fonts.ralewayBold, size: 14))
                    Text(movie.description)
                        .font(.custom(Fonts.ralewayRegular, fixedSize: 12))
                        .foregroundColor(Color(.descriptionText))
                    Text("Release: \(movie.releaseDate)")
                        .font(.custom(Fonts.ralewaySemiBold, fixedSize: 12))
                        .foregroundColor(Color(.accentOrange))
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
                    .frame(width: 128, height: 188)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(width: 128)
            }
        }
        
    }
}

#Preview {
    MovieCard(movie: Movie.mockMovie, viewModel: MoviesViewModel(networkManager: NetworkManager()))
}
