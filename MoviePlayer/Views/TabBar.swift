//
//  TabBar.swift
//  MoviePlayer
//
//  Created by DimMac on 18.09.2024.
//

import SwiftUI

struct TabBar: View {
    
    var body: some View {
        TabView {
            MovieList()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            FavouriteMoviesView()
                .tabItem {
                    Label("Favourite", systemImage: "star")
                }
        }
        .accentColor(Color.accent)
    }
}

extension Color {
    static var accent: Color {
        return Color("MainAccentColor")
    }
    static var description: Color {
        return Color("DescriptionTextColor")
    }
}

#Preview {
    TabBar()
}
