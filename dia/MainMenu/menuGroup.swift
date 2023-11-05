//
//  mainMenuGroup.swift
//  dia
//
//  Created by Артём Исаков on 20.01.2023.
//

import SwiftUI

struct mainGroup: View {
    @EnvironmentObject var routeManager: Router
    @StateObject var collection = foodCollections()
    var body: some View {
        TabView(selection: $routeManager.tabViewStatment) {
            if #available(iOS 16, *) {
                NavigationStack {
                    mainMenu()
                        .showTabBar()
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
                        .showTabBar()
                }
                .tabItem {
                    Label("Рецепты", systemImage: "character.book.closed")
                }
                .tag(2)
                .onAppear {
                    URLCache.shared.memoryCapacity = 50_000_000
                    URLCache.shared.diskCapacity = 1_000_000_000
                }
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
                .onAppear {
                    URLCache.shared.memoryCapacity = 50_000_000
                    URLCache.shared.diskCapacity = 1_000_000_000
                }
            }
            if #available(iOS 16, *) {
                NavigationStack {
                    settings()
                        .showTabBar()
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
