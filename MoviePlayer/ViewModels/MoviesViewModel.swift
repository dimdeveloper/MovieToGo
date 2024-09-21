//
//  MoviesViewModel.swift
//  MovieToGo
//
//  Created by DimMac on 19.09.2024.
//

import Foundation
import UIKit

enum LoadState {
    case isLoading
    case notLoading
}

class MoviesViewModel: ObservableObject {
    
    var loadState: LoadState = .isLoading
    @Published var movies: [Movie] = []
    
    let networkManager = NetworkCall()
    var currentMoviesPage = 1
    var pagesCount = 1
    var errorMessage: String = ""
    
    func loadImage(imagePath: String?, completion: @escaping (Data) -> Void) {
        guard let path = imagePath else {return}
        networkManager.loadImageData(imagePath: path) { data in
            completion(data)
        }
    }
    
    func fetchMovies() {
        let pageQuery = URLQueryItem(name: "page", value: String(currentMoviesPage))
        networkManager.loadData(queryItem: pageQuery) { responce in
            switch responce {
            case .success(let result):
                
                let fetchedMovies = self.modelMap(fetchResult: result)
                if self.movies.isEmpty {
                    self.movies = fetchedMovies
                } else {
                    self.movies.append(contentsOf: fetchedMovies)
                }
                
            case .failure(let error):
                self.requestErrorHandling(error: error)
            }
        }
    }
    
    private func requestErrorHandling(error: RequestError){
        switch error {
        case .error(statusCode: let statusCode, data: let _):
            self.errorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
        case .notConnected, .generic(_):
            self.errorMessage = "Network Error"
        case .urlGeneration:
            self.errorMessage = "Invalid URL"
        case .cancelled:
            break
        case .dataError:
            self.errorMessage = "Invalid data responce"
        case .decodeError:
            self.errorMessage = "Invalid data decode"
        }
    }
}

// MARK: Mapping to entity model

extension MoviesViewModel {
    func modelMap(fetchResult: MoviesResponce) -> [Movie] {
        var movies: [Movie] = []
        self.currentMoviesPage = fetchResult.page
        self.pagesCount = fetchResult.totalPages
        fetchResult.results.forEach { result in
            let movieName = result.originalTitle ?? "Undefined"
            let description = result.overview ?? "..."
            let posterPath = result.posterPath
            let backdropPath = result.backdropPath
            let voteGrade = result.voteAverage != nil ? String(format: "%.1f", result.voteAverage!) : "-"
            let dateString = result.releaseDate != nil ? formatDate(from: result.releaseDate!) : "--/--/--"
            let movie = Movie(name: movieName, description: description, releaseDate: dateString, posterPath: posterPath, backdropPath: backdropPath, voteAverage: voteGrade)
            movies.append(movie)
        }
        return movies
    }
    
    private func formatDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        let date = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
}
