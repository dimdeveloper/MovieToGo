//
//  DwnloadManager.swift
//  MovieToGo
//
//  Created by DimMac on 18.09.2024.
//

import Foundation

enum RequestError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case generic(Error)
    case urlGeneration
    case cancelled
    case dataError
    case decodeError
}

class NetworkCall {
    
    typealias CompletionHandler = (Result<[Movie], RequestError>) -> Void
    
    let baseURL = "https://api.themoviedb.org/3/movie/popular"
    let imageBaseURL = "https://image.tmdb.org/t/p/w500/"
    let apiKey = "?api_key=ed0957c3c3f2acb89d27b394e9612d5e"
    
    func loadData(completion: @escaping CompletionHandler){
        guard let url = URL(string: baseURL + apiKey) else {
            completion(.failure(.urlGeneration))
            return
        }
        URLSession.shared.dataTask(with: url) { data, responce, error in
            
            if let error = error {
                var requestError: RequestError
                if let responce = responce as? HTTPURLResponse {
                    requestError = .error(statusCode: responce.statusCode, data: data)
                } else {
                    requestError = self.handleNetworkError(error: error)
                }
                completion(.failure(requestError))
            }
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            if let movies = try? JSONDecoder().decode(MoviesResponce.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(movies.modelMap()))
                }
            } else {
                completion(.failure(.decodeError))
            }
            
        }.resume()
    }
    
    func handleNetworkError(error: Error) -> RequestError {
        let errorCode = URLError.Code(rawValue: (error as NSError).code)
        switch errorCode {
        case .notConnectedToInternet: 
            return .notConnected
        case .cancelled: 
            return .cancelled
        default: 
            return .generic(error)
        }
    }
}
