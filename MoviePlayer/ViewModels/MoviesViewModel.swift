//
//  MoviesViewModel.swift
//  MovieToGo
//
//  Created by DimMac on 19.09.2024.
//

import Foundation

class MoviesViewModel {
    var movies: [Movie]?
    
    let networkManager = NetworkCall()
    
    func fetchMovies(completion: @escaping ([Movie]) -> Void) {
        networkManager.loadData { responce in
            switch responce {
 
            case .success(let result):
                completion(result)
            case .failure(_):
                break
            }
        }
    }
}
