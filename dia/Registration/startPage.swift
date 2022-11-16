//
//  startPage.swift
//  dia
//
//  Created by Артём Исаков on 20.08.2022.
//

import SwiftUI

struct startPage: View {
    @StateObject private var loginManager = Router()
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        if #available(iOS 16.0, *) {
            Group {
                if (loginManager.isLoggedIn && loginManager.isChoosed) {
                    NavigationStack {
                        mainPage(txtTheme: $txtTheme)
                    }
                }
                if (!loginManager.isLoggedIn || !loginManager.isChoosed) {
                    NavigationStack(path: $loginManager.path) {
                        loginPage(txtTheme: $txtTheme)
                            .navigationDestination(for: Route.self) { route in
                                switch route {
                                case .login:
                                    loginPage(txtTheme: $txtTheme)
                                case .password:
                                    passwordPage(txtTheme: $txtTheme)
                                case .version:
                                    versionChoose()
                                case .helper:
                                    regHelper()
                                }
                            }
                    }
                }
            }
            .transition(.slide)
            .animation(Animation.default, value: loginManager.animateTransition)
            .onAppear {
                loginManager.checkIfLogged()
            }
            .environmentObject(loginManager)
        } else {
            NavigationView {
                if (loginManager.isLoggedIn && loginManager.isChoosed) {
                    mainPage(txtTheme: $txtTheme)
                }
                if (!loginManager.isLoggedIn || !loginManager.isChoosed) {
                    loginPage(txtTheme: $txtTheme)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                loginManager.checkIfLogged()
            }
            .environmentObject(loginManager)
        }
    }
}
