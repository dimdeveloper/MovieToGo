//
//  MovieList.swift
//  MoviePlayer
//
//  Created by DimMac on 18.09.2024.
//

import SwiftUI

struct MovieList: View {
    
    @StateObject var viewModel = MoviesViewModel(networkManager: NetworkManager())
    
    
    var body: some View {
        
        ZStack {
            //            VStack {
            //                Image("wifi.exclamationmark")
            //                    .foregroundColor(Color.accent)
            //                Text("No internet connection!")
            //            }
            VStack {
                if viewModel.movies.isEmpty {
                    ActivityIndicator()
                } else {
                    NavigationView {
                        VStack {
                            List(viewModel.movies) { movie in
                                MovieCard(movie: movie, viewModel: viewModel)
                                    .overlay(NavigationLink(destination: MovieDetailView(viewModel: viewModel, movie: movie)) {
                                    }.fixedSize().opacity(0.0))
                                if viewModel.movies.last?.id == movie.id {
                                    if viewModel.currentMoviesPage < viewModel.pagesCount {
                                        LastRowListView(viewModel: viewModel)
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
            .alert(Text(viewModel.errorMessage), isPresented: $viewModel.showAlert) {
                Button("OK") { viewModel.errorMessage = "" }
            }
            .onAppear(){
                viewModel.fetchMovies()
            }
        }
    }
}

struct LastRowListView: View {
    
    var viewModel: MoviesViewModel
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack() {
                Spacer()
                ActivityIndicator()
                Spacer()
            }
        }
        .frame(height: 50)
        .onAppear(){
            viewModel.currentMoviesPage += 1
            viewModel.fetchMovies()
        }
    }
}

struct ActivityIndicator: View {
    var tintColor: Color = .orange
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
            .scaleEffect(1)
    }
}
    
#Preview {
    MovieList()
}
