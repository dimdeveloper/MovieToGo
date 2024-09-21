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
    @State var isAlertShow = false
    
    var body: some View {
        
        ZStack {
            VStack {
                Image("wifi.exclamationmark")
                    .foregroundColor(Color.accent)
                Text("No internet connection!")
            }
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
                                    if viewModel.currentMoviesPage < viewModel.pagesCount {
                                        LastRowListView(viewModel: viewModel, movies: $movies, showError: $isAlertShow)
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
            .alert(isPresented: $isAlertShow) {
                Alert(title: Text(viewModel.errorMessage))
            }
        }
        .onAppear(){
            viewModel.fetchMovies { result in
                switch result {
                case .success(let result):
                    self.movies = result
                case .failure(let error):
                    isAlertShow = true
                }
                self.isLoading = false
            }
        }
    }
}

struct LastRowListView: View {
    
    var viewModel: MoviesViewModel
    @Binding var movies: [Movie]
    @Binding var showError: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack() {
                Spacer()
                switch viewModel.loadState {
                case .isLoading:
                    ActivityIndicator()
                case .notLoading:
                    EmptyView()
                }
                Spacer()
            }
        }
        .frame(height: 50)
        .onAppear(){
            viewModel.loadState = .notLoading
            viewModel.currentMoviesPage += 1
            viewModel.fetchMovies { result in
                if case let .success(data) = result {
                    self.movies.append(contentsOf: data)
                } else {
                    showError = true
                }
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
