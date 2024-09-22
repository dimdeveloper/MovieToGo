//
//  MoviesViewModel.swift
//  MovieToGo
//
//  Created by DimMac on 19.09.2024.
//

import Foundation
import UIKit

enum ErrorMessage: String {
    case networkErrorMessage = "Network Error"
    case responceErrorMessage = "Error getting data"
    
    static var networkError: String {
        ErrorMessage.networkErrorMessage.rawValue
    }
    static var responceError: String {
        ErrorMessage.responceErrorMessage.rawValue
    }
}

class MoviesViewModel: ObservableObject {
    
    @Published var showAlert = false
    @Published var movies: [Movie] = []
    
    
    var errorMessage: String = "" {
        didSet {
            if oldValue.isEmpty && !errorMessage.isEmpty {
                showAlert = true
            }
        }
    }
    
    var networkManager: NetworkManager
    var currentMoviesPage: Int
    var pagesCount: Int
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.currentMoviesPage = 1
        self.pagesCount = 1
    }
    
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
                self.errorMessage = ""
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.requestErrorHandling(error: error)
                } 
            }
        }
    }
    
    private func requestErrorHandling(error: RequestError) {
        switch error {
        case .error(statusCode: let statusCode, data: let data):
            self.errorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
        case .notConnected:
            self.errorMessage = ErrorMessage.networkError
        case .urlGeneration:
            self.errorMessage = ErrorMessage.responceError
        case .dataError:
            self.errorMessage = ErrorMessage.responceError
        case .decodeError:
            self.errorMessage = ErrorMessage.responceError
        case .generic(_):
            self.errorMessage = ErrorMessage.responceError
        }
    }
}

// MARK: Mapping to entity model

extension MoviesViewModel {
    
    private func modelMap(fetchResult: MoviesResponce) -> [Movie] {
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
