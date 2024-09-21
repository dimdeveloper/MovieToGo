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
    
    typealias CompletionHandler = (Result<MoviesResponce, RequestError>) -> Void
    
    let baseURL = "https://api.themoviedb.org/3/movie/popular"
    var imageURL = "https://image.tmdb.org/t/p/w500/"
    let apiKeyName = "api_key"
    let apiKeyValue = "ed0957c3c3f2acb89d27b394e9612d5e"
    
    
    func loadData(queryItem: URLQueryItem, completion: @escaping CompletionHandler){
        guard var url = URL(string: baseURL) else {
            completion(.failure(.urlGeneration))
            return
        }
        var queryItems: [URLQueryItem] = [URLQueryItem(name: apiKeyName, value: apiKeyValue)]
        queryItems.append(queryItem)
        url.appendQueryItems(with: queryItems)
        URLSession.shared.dataTask(with: url) { data, responce, error in
            
            if let error = error {
                var requestError: RequestError
                if let responce = responce as? HTTPURLResponse {
                    requestError = .error(statusCode: responce.statusCode, data: data)
                } else {
                    requestError = self.handleNetworkError(error: error)
                }
                completion(.failure(requestError))
                return
            }
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            if let result = try? JSONDecoder().decode(MoviesResponce.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodeError))
            }
            
        }.resume()
    }
    
    func loadImageData(imagePath: String, completion: @escaping (Data) -> Void){
        if let url = URL(string: imageURL + imagePath) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    completion(data)
                }
            }
            
            task.resume()
        }
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


extension URL {
    mutating func appendQueryItems(with queryItems: [URLQueryItem]){
        
        guard var urlComponents = URLComponents(string: absoluteString) else {return}
        
        var items: [URLQueryItem] = urlComponents.queryItems ?? []
        items.append(contentsOf: queryItems)
        urlComponents.queryItems = items
        self = urlComponents.url!  
    }
}
