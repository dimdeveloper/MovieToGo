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
    }
}

#Preview {
    TabBar()
}
