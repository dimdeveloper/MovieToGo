//
//  MovieDetailView.swift
//  MoviePlayer
//
//  Created by DimMac on 18.09.2024.
//

import SwiftUI

struct MovieDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var image: Image?
    
    var viewModel: MoviesViewModel
    var movie: Movie
    
    var body: some View {

        ScrollView {
            MovieInfoView(image: $image, movie: movie)
        }
        .onAppear {
            viewModel.loadImage(imagePath: movie.backdropPath) { data in
                guard let image = UIImage(data: data) else {return}
                self.image = Image(uiImage: image)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigation) {
                Button(action: {dismiss()}){
                    Image(ImageNames.backButton)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Image(ImageNames.logo)
            }
        })
    }
}

private struct MovieInfoView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var isAlertShow = false
    @Binding var image: Image?
    
    var movie: Movie
    
    var body: some View {
        
        ZStack {
            if verticalSizeClass == .regular {
                VStack(spacing: 20){
                    MoviewPreviewImage(image: $image, movie: movie)
                        .onTapGesture {
                            isAlertShow = true
                        }
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Description:")
                            .font(.custom(Fonts.ralewaySemiBold, fixedSize: 16))
                        Text(movie.description)
                            .font(.custom(Fonts.ralewayRegular, fixedSize: 14))
                            .foregroundColor(Color(.descriptionText))
                        Text("Release: \(movie.releaseDate)")
                            .font(.custom(Fonts.ralewaySemiBold, fixedSize: 14))
                            .foregroundColor(Color(.accentOrange))
                    }
                }
            } else {
                HStack(alignment: .top) {
                    MoviewPreviewImage(image: $image, movie: movie)
                        .onTapGesture {
                            isAlertShow = true
                        }
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Description:")
                            .font(.custom(Fonts.ralewaySemiBold, fixedSize: 16))
                        Text(movie.description)
                            .font(.custom(Fonts.ralewayRegular, fixedSize: 14))
                            .foregroundColor(Color(.descriptionText))
                        Text("Release: \(movie.releaseDate)")
                            .font(.custom(Fonts.ralewaySemiBold, fixedSize: 14))
                            .foregroundColor(Color(.accentOrange))
                    }
                }
            }
        }
        .padding()
        .alert(isPresented: $isAlertShow, content: {
            Alert(title: Text(movie.name))
        })
    }
}

private struct MoviewPreviewImage: View {
    
    @Binding var image: Image?
    
    var movie: Movie
    
    var body: some View {
        VStack{
            if let movieImage = image {
                movieImage
                    .resizable()
                    .scaledToFit()
                    .overlay(alignment: .center, content: {
                        ZStack {
                            Image(ImageNames.ellipse)
                            Image(ImageNames.arrow)
                        }
                    })
                    .overlay(alignment: .bottom) {
                        HStack {
                            Text(movie.name)
                                .foregroundColor(.white)
                                .font(.custom(Fonts.ralewayBold, size: 16))
                                .fontWeight(.bold)
                            Spacer()
                            Text(movie.voteAverage)
                                .foregroundColor(.white)
                                .font(.custom(Fonts.ralewaySemiBold, fixedSize: 12))
                            Image(ImageNames.star)
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal, 12)
                    }
            } else {
                Image(ImageNames.imagePlaceholder)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(maxWidth: 500)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

#Preview {
    MovieDetailView(image: nil, viewModel: MoviesViewModel(networkManager: NetworkManager()), movie: Movie.mockMovie)
}
