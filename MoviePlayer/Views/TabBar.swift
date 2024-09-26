//
//  TabBar.swift
//  MoviePlayer
//
//  Created by DimMac on 18.09.2024.
//

import SwiftUI

enum TabItemName: String {
    case home = "Home"
    case favourite = "Favourite"
}

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
                        TabLabel(name: .home, isActive: true)
                    } else {
                        TabLabel(name: .home, isActive: false)
                    }
                   
                }.tag(0)
            FavouriteMoviesView()
                .tabItem {
                    if selection == 1 {
                        TabLabel(name: .favourite, isActive: true)
                    } else {
                        TabLabel(name: .favourite, isActive: false)
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

struct TabLabel: View {
    var name: TabItemName
    let labelFont = Fonts.sfProTextMedium
    let fontSize: CGFloat = 10
    var isActive: Bool
    var activeImage: String
    var inactiveImage: String
    
    init(name: TabItemName, isActive: Bool) {
        self.name = name
        self.isActive = isActive
        switch name {
        
        case .home:
            activeImage = ImageNames.activeHome
            inactiveImage = ImageNames.inactiveHome
        case .favourite:
            activeImage = ImageNames.activeFavourite
            inactiveImage = ImageNames.inactiveFavourite
        }
    }
    
    var body: some View {
        Label(
            title: { Text(name.rawValue)
                    .font(.custom(labelFont, size: fontSize))
            },
            icon: { Image(isActive == true ? activeImage : inactiveImage)
            }
        )
    }
}

extension UIImage {
    static func shadowImage(bounds: CGRect, colors: [CGColor]) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}

#Preview {
    TabBar()
}
