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
    case dataError
    case decodeError
}

class NetworkManager {
    
    typealias CompletionHandler = (Result<MoviesResponce, RequestError>) -> Void

    let apiKeyName = "api_key"
    let appConfig = AppConfig()
    
    func loadData(queryItem: URLQueryItem, completion: @escaping CompletionHandler){
        guard var url = URL(string: appConfig.baseURL) else {
            completion(.failure(.urlGeneration))
            return
        }
        
        var queryItems: [URLQueryItem] = [URLQueryItem(name: apiKeyName, value: appConfig.apiKey)]
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
        if let url = URL(string: appConfig.imageURL + imagePath) {
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
        default: 
            return .generic(error)
        }
    }
}


extension URL {
    mutating func appendQueryItems(with queryItems: [URLQueryItem]) {
        guard var urlComponents = URLComponents(string: absoluteString) else {return}
        
        var items: [URLQueryItem] = urlComponents.queryItems ?? []
        items.append(contentsOf: queryItems)
        urlComponents.queryItems = items
        self = urlComponents.url!  
    }
}
