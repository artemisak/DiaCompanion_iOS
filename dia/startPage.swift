//
//  startPage.swift
//  dia
//
//  Created by Артём Исаков on 20.08.2022.
//

import SwiftUI

struct startPage: View {
    @StateObject var routeManager = Router()
    var body: some View {
        if #available(iOS 16.0, *) {
            Group {
                if (routeManager.isLoggedIn && routeManager.isChoosed) {
                    mainGroup()
                }
                if (!routeManager.isLoggedIn || !routeManager.isChoosed) {
                    NavigationStack {
                        loginPage()
                    }
                }
            }
            .transition(.slide)
            .animation(Animation.default, value: routeManager.animateTransition)
            .onAppear {
                routeManager.checkIfLogged()
            }
            .environmentObject(routeManager)
            
        } else {
            Group {
                if (routeManager.isLoggedIn && routeManager.isChoosed) {
                    mainGroup()
                }
                if (!routeManager.isLoggedIn || !routeManager.isChoosed) {
                    NavigationView {
                        loginPage()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                }
            }
            .transition(.slide)
            .animation(Animation.default, value: routeManager.animateTransition)
            .onAppear {
                routeManager.checkIfLogged()
            }
            .environmentObject(routeManager)
        }
    }
}
