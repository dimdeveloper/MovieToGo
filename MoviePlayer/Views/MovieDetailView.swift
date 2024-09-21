//
//  MovieDetailView.swift
//  MoviePlayer
//
//  Created by DimMac on 18.09.2024.
//

import SwiftUI

struct MovieDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    var viewModel: MoviesViewModel
    var movie: Movie
    @State var image: Image?
    
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

private struct MovieInfoView: View {
    @State var isAlertShow = false
    @Binding var image: Image?
    var movie: Movie
    
    var body: some View {
        VStack(spacing: 20){
            MoviewPreviewImage(image: $image, movie: movie)
                .onTapGesture {
                    isAlertShow = true
                }
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
        .alert(isPresented: $isAlertShow, content: {
            Alert(title: Text(movie.name))
        })
    }
}

struct MoviewPreviewImage: View {
    
    @Binding var image: Image?
    var movie: Movie
    var imageURL = "https://image.tmdb.org/t/p/w500/"
    
    var body: some View {
        VStack{
            if let movieImage = image {
                movieImage
                    .resizable()
                    .scaledToFit()
                    .overlay(alignment: .center, content: {
                        ZStack {
                            Image("Ellipse")
                            Image("Arrow")
                        }
                    })
                    .overlay(alignment: .bottom) {
                        HStack {
                            Text(movie.name)
                                .foregroundColor(.white)
                                .font(.custom("Raleway", fixedSize: 16))
                                .fontWeight(.bold)
                            Spacer()
                            Text(movie.voteAverage)
                                .foregroundColor(.white)
                                .font(.custom("Raleway", fixedSize: 12))
                            Image("star")
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal, 12)
                    }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
        }
        .frame(maxWidth: 500)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

#Preview {
    MovieDetailView(viewModel: MoviesViewModel(), movie: Movie(name: "Saving Bikini Bottom: The Sandy Cheeks Movie", description: "When Bikini Bottom is scooped from the ocean, scientific squirrel Sandy Cheeks and her pal SpongeBob SquarePants saddle up for Texas to save their town.", releaseDate: "2024-08-01", posterPath: "", backdropPath: "", voteAverage: "6.08"), image: nil)
}
