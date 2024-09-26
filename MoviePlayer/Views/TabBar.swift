//
//  TabBar.swift
//  MoviePlayer
//
//  Created by DimMac on 18.09.2024.
//

import SwiftUI

struct TabBar: View {
    
    @State var selection = 0
    let shadowColor = CGColor(red: 255, green: 255, blue: 255, alpha: 0.16)
    let shadowHeight: CGFloat = 4
    
    init(){
        setupTabBarShadow()
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
    
    private func setupTabBarShadow(){
        let image = UIImage.shadowImage(bounds: CGRect(x: 0, y: 0, width: UIScreen.main.scale, height: shadowHeight), colors: [UIColor.clear.cgColor, shadowColor])
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.white
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = image
    
        UITabBar.appearance().standardAppearance = appearance
    }
}

extension UIImage {
    static func shadowImage(bounds: CGRect, colors: [CGColor]) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}

#Preview {
    TabBar()
}
