//
//  startPage.swift
//  dia
//
//  Created by Артём Исаков on 20.08.2022.
//

import SwiftUI

enum Route: Hashable {
    case login
    case password
    case version
    case helper
}

struct RouteStruct: Hashable {
    var pages: Route
    @ViewBuilder
    func makeView() -> some View {
        switch pages {
        case .login:
            loginPage()
        case .password:
            passwordPage()
        case .version:
            versionChoose()
        case .helper:
            regHelper()
        }
    }
}

struct startPage: View {
    @StateObject private var loginManager = Router()
    @StateObject var collection = foodCollections()
    var body: some View {
        if #available(iOS 16.0, *) {
            Group {
                if (loginManager.isLoggedIn && loginManager.isChoosed) {
                    NavigationStack {
                        mainPage()
                    }
                }
                if (!loginManager.isLoggedIn || !loginManager.isChoosed) {
                    NavigationStack {
                        loginPage()
                            .navigationDestination(for: RouteStruct.self) { route in
                                route.makeView()
                            }
                    }
                }
            }
            .transition(.slide)
            .animation(Animation.default, value: loginManager.animateTransition)
            .onAppear {
                loginManager.checkIfLogged()
            }
            .environmentObject(collection)
            .environmentObject(loginManager)
            
        } else {
            Group {
                if (loginManager.isLoggedIn && loginManager.isChoosed) {
                    NavigationView {
                        mainPage()
                    }
                }
                if (!loginManager.isLoggedIn || !loginManager.isChoosed) {
                    NavigationView {
                        loginPage()
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .transition(.slide)
            .animation(Animation.default, value: loginManager.animateTransition)
            .onAppear {
                loginManager.checkIfLogged()
            }
            .environmentObject(loginManager)
            .environmentObject(collection)
        }
    }
}
