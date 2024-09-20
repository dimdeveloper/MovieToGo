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
    var currentMoviesPage = 4
    
    func loadImage(imagePath: String, completion: @escaping (Data) -> Void) {
        networkManager.loadImageData(imagePath: imagePath) { data in
            completion(data)
        }
    }
    
    func fetchMovies(completion: @escaping ([Movie]) -> Void) {
        let pageQuery = URLQueryItem(name: "page", value: String(currentMoviesPage))
        networkManager.loadData(queryItem: pageQuery) { responce in
            switch responce {
            case .success(let result):
                completion(result)
            case .failure(_):
                break
            }
        }
    }
}
