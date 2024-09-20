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
                        VStack {
                            List(movies) { movie in
                                MovieCard(movie: movie, viewModel: viewModel)
                                    .overlay(NavigationLink(destination: MovieDetailView(viewModel: viewModel, movie: movie)) {
                                    }.fixedSize().opacity(0.0))
                                if movies.last?.id == movie.id {
                                    if viewModel.currentMoviesPage < 46099 {
                                        LastRowListView(viewModel: viewModel, movies: $movies)
                                    }
                                }
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
                    }
                    .listRowSpacing(20)
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

struct LastRowListView: View {
    
    var viewModel: MoviesViewModel
    @Binding var movies: [Movie]
    
    var body: some View {
        ZStack() {
            VStack(alignment: .center) {
                switch viewModel.loadState {
                case .isLoading:
                    ActivityIndicator()
                case .notLoading:
                    EmptyView()
                }
            }
        }
        .frame(height: 50)
        .onAppear(){
            viewModel.loadState = .notLoading
            viewModel.currentMoviesPage += 1
            viewModel.fetchMovies { result in
                self.movies.append(contentsOf: result)
                viewModel.loadState = .isLoading
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
