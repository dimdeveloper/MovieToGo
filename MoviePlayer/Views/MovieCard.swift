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
    let horizontalSpacing: CGFloat = 20
    let verticalSpacing: CGFloat = 12
    let cornerRadius: CGFloat = 12
    
    var body: some View {
        ZStack {
            HStack(alignment: .top, spacing: horizontalSpacing) {
               
                MovieImage(image: image)
                
                VStack(alignment: .leading, spacing: verticalSpacing) {
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
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

private struct MovieImage: View {
    
    var image: Image?
    let imageWidth: CGFloat = 128
    let imageHeight: CGFloat = 188
    let cornerRadius: CGFloat = 8
    
    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageWidth, height: imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(width: imageWidth)
            }
        }
        
    }
}

#Preview {
    MovieCard(movie: Movie.mockMovie, viewModel: MoviesViewModel(networkManager: NetworkManager()))
}
