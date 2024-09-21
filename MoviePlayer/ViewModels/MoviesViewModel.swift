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

class MoviesViewModel {
    
    var loadState: LoadState = .isLoading
    var movies: [Movie]?
    
    let networkManager = NetworkCall()
    var currentMoviesPage = 1
    var pagesCount = 1
    var errorMessage: String = ""
    
    func loadImage(imagePath: String, completion: @escaping (Data) -> Void) {
        networkManager.loadImageData(imagePath: imagePath) { data in
            completion(data)
        }
    }
    
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let pageQuery = URLQueryItem(name: "page", value: String(currentMoviesPage))
        networkManager.loadData(queryItem: pageQuery) { responce in
            switch responce {
            case .success(let result):
                completion(.success(self.modelMap(fetchResult: result)))
            case .failure(let error):
                switch error {
                case .error(statusCode: let statusCode, data: let data):
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
                completion(.failure(error))
            }
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
            let voteGrade = String(format: "%.1f", result.voteAverage)
            let dateString = formatDate(from: result.releaseDate)
            let movie = Movie(name: result.originalTitle, description: result.overview, releaseDate: dateString, posterPath: result.posterPath, backdropPath: result.backdropPath, voteAverage: voteGrade)
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
