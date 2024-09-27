//
//  Constants.swift
//  MovieToGo
//
//  Created by DimMac on 26.09.2024.
//

import Foundation

enum ImageNames {
    static let activeHome = "HomeIcon"
    static let inactiveHome = "HomeInactive"
    static let activeFavourite = "Favourite"
    static let inactiveFavourite = "FavouriteInactive"
    static let logo = "Logo"
    static let backButton =  "BackButton"
    static let ellipse = "Ellipse"
    static let arrow = "Arrow"
    static let star = "Star"
    static let detailMoviewGradient = "Gradient"
    static let wifiError = "wifi.exclamationmark"
    
}

struct Defaults {
    static let name = "Undefined"
    static let description = "..."
    static let voteGrade = "-"
    static let date = "--/--/--"
}

struct LoggerMessages {
    static let connectionError = "Invalid network connection"
    static let urlError = "Invalid URL"
    static let dataRetreiveError = "Error data retreiving"
    static let dataDecodeError = "Invalid data decoding"
    static let genericError = "Generic error"
    static let fetchSucess = "movies fetched successfully"
}
