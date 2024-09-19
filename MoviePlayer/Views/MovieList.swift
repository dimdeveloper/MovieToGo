//
//  MovieList.swift
//  MoviePlayer
//
//  Created by DimMac on 18.09.2024.
//

import SwiftUI

struct MovieList: View {
    var viewModel = MoviesViewModel()
    @State var movies = [Movie]()
    @State var isLoading = true
    
    var body: some View {
        
        ZStack {
            VStack {
                if isLoading{
                    ActivityIndicator()
                } else {
                    NavigationView {
                        List(movies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                
                                MovieCard(movie: movie)
                                
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                VStack {
                                    Spacer()
                                    Image("Logo")
                                }
                            }
                        }
                        .listRowSpacing(20)
                        
                    }
                    
                }
                
                
            }
        }
        .onAppear(){
            viewModel.fetchMovies { result in
                self.movies = result
                self.isLoading = false
            }
        }
    }
}


struct ActivityIndicator: View {
    var tintColor: Color = .orange
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}
#Preview {
    MovieList()
}
