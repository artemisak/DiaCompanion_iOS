//
//  mainMenuGroup.swift
//  dia
//
//  Created by Артём Исаков on 20.01.2023.
//

import SwiftUI

struct mainMenuGroup: View {
    @EnvironmentObject var routeManager: Router
    @StateObject var collection = foodCollections()
    var body: some View {
        TabView(selection: $routeManager.tabViewStatment) {
            if #available(iOS 16, *) {
                NavigationStack {
                    mainMenu()
                }
                .tabItem {
                    Label("Главная", systemImage: "house")
                }
                .tag(1)
            } else {
                NavigationView {
                    mainMenu()
                        .showTabBar()
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Главная", systemImage: "house")
                }
                .tag(1)
            }
            if #available(iOS 16, *) {
                NavigationStack {
                    recipeAsyncList()
                }
                .tabItem {
                    Label("Рецепты", systemImage: "character.book.closed")
                }
                .tag(2)
            } else {
                NavigationView {
                    recipeAsyncList()
                        .showTabBar()
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Рецепты", systemImage: "character.book.closed")
                }
                .tag(2)
            }
            if #available(iOS 16, *) {
                NavigationStack {
                    settings()
                }
                .tabItem {
                    Label("Дополнительно", systemImage:  "gearshape")
                }
                .tag(3)
            } else {
                NavigationView {
                    settings()
                        .showTabBar()
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Дополнительно", systemImage:  "gearshape")
                }
                .tag(3)
            }
        }
        .environmentObject(collection)
    }
}

struct mainMenuGroup_Previews: PreviewProvider {
    static var previews: some View {
        mainMenuGroup()
    }
}
