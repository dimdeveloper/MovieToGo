//
//  MovieList.swift
//  MoviePlayer
//
//  Created by DimMac on 18.09.2024.
//

import SwiftUI

struct MovieList: View {
    
    @StateObject var viewModel = MoviesViewModel(networkManager: NetworkManager())
    private var verticalSpacing: CGFloat = 20
    
    var body: some View {
        
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            if !viewModel.errorMessage.isEmpty && viewModel.movies.isEmpty {
                
                ConnectionErrorView(viewModel: viewModel)
                
            } else {
                VStack {
                    if viewModel.movies.isEmpty {
                        ActivityIndicator()
                    } else {
                        NavigationView {
                            VStack {
                                List(viewModel.movies) { movie in
                                    
                                    MovieCard(movie: movie, viewModel: viewModel)
                                        .listRowInsets(.init(top: 20, leading: 16, bottom: 20, trailing: 16))
                                        .overlay(NavigationLink(destination: MovieDetailView(viewModel: viewModel, movie: movie)) {
                                        }.fixedSize().opacity(0.0))
                                    
                                    
                                    if viewModel.movies.last?.id == movie.id {
                                        if viewModel.currentMoviesPage < viewModel.pagesCount {
                                            LastRowListView(viewModel: viewModel)
                                        }
                                    }
                                }
                                .listRowSpacing(verticalSpacing)
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    VStack {
                                        Spacer()
                                        Image(ImageNames.logo)
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear(){
                    viewModel.fetchMovies()
                }
            }
            
            
        }
        .alert(Text(viewModel.errorMessage), isPresented: $viewModel.showAlert) {
            Button("OK") {}
        }
    }
}

struct ConnectionErrorView: View {
    
    var viewModel: MoviesViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: ImageNames.wifiError)
                .foregroundColor(Color(.accentOrange))
                .scaleEffect(2)
            Text(viewModel.errorMessage)
            
            Button("Update") {
                viewModel.errorMessage = ""
                viewModel.fetchMovies()
            }
            .buttonStyle(.borderedProminent)
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
    
    var tintColor: Color = Color(.accentOrange)
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}
    
#Preview {
    MovieList()
}
