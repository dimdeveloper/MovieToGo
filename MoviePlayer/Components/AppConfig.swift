//
//  AppConfiguration.swift
//  MovieToGo
//
//  Created by DimMac on 22.09.2024.
//

import Foundation

struct Config: Decodable {
    let apiKey: String
    let popularMoviesURL: String
    let imageURL: String
}

final class AppConfig {
   
    let config: Config?
    
    init(){
        guard let url = Bundle.main.url(forResource: "Config", withExtension: "plist") else {
            fatalError("Error finding Config file")
        }
        do {
            let data = try Data(contentsOf: url)
            config = try PropertyListDecoder().decode(Config.self, from: data)
        } catch {
            config = nil
        }
    }
    
    lazy var apiKey: String = {
        guard let apiKey = config?.apiKey as? String else {
            fatalError("Error finding ApiKey in plist")
        }
        return apiKey
    }()
    
    lazy var baseURL: String = {
        guard let popularMoviesURL = config?.popularMoviesURL as? String else {
            fatalError("Error finding imageURL in plist")
        }
        return popularMoviesURL
    }()
    
    lazy var imageURL: String = {
        guard let imageURL = config?.imageURL as? String else {
            fatalError("Error finding ApiKey in plist")
        }
        return imageURL
    }()
}
