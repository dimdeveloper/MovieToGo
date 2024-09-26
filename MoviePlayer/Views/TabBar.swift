//
//  TabBar.swift
//  MoviePlayer
//
//  Created by DimMac on 18.09.2024.
//

import SwiftUI

struct TabBar: View {
    
    @State var selection = 0
    
    init(){
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color(.greyInactive))
    }
    
    var body: some View {
        TabView(selection: $selection) {
            MovieList()
                .tabItem {
                    if selection == 0 {
                        Label(
                            title: { Text("Home")
                                    .font(.custom(Fonts.sfProTextMedium, size: 10))
                            },
                            icon: { Image(ImageNames.activeHome)
                            }
                        )
                    } else {
                        Label(
                            title: { Text("Home")
                                    .font(.custom(Fonts.sfProTextMedium, size: 10))
                            },
                            icon: { Image(ImageNames.inactiveHome)
                            }
                        )
                    }
                   
                }.tag(0)
            FavouriteMoviesView()
                .tabItem {
                    if selection == 1 {
                        Label(
                            title: { Text("Favourite")
                                    .font(.custom(Fonts.sfProTextMedium, size: 10))
                            },
                            icon: { Image(ImageNames.activeFavourite)
                            }
                        )
                    } else {
                        Label(
                            title: { Text("Favourite")
                                    .font(.custom(Fonts.sfProTextMedium, size: 10))
                            },
                            icon: { Image(ImageNames.inactiveFavourite)
                            }
                        )
                    }
                }.tag(1)
        }
        .accentColor(Color(.accentOrange))
    }
}

#Preview {
    TabBar()
}
