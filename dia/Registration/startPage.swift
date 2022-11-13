//
//  startPage.swift
//  dia
//
//  Created by Артём Исаков on 20.08.2022.
//

import SwiftUI

struct startPage: View {
    @StateObject private var islogin = check()
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                if islogin.istrue {
                    if islogin.isChoosed {
                        mainPage(txtTheme: $txtTheme)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarBackButtonHidden()
                    }
                    if !islogin.isChoosed {
                        versionChoose()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarBackButtonHidden()
                    }
                }
                if !islogin.istrue {
                    loginPage(txtTheme: $txtTheme)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden()
                }
            }
            .onAppear {
                islogin.checklog()
            }
            .environmentObject(islogin)
        } else {
            NavigationView {
                if islogin.istrue {
                    if islogin.isChoosed {
                        mainPage(txtTheme: $txtTheme)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarBackButtonHidden()
                    }
                    if !islogin.isChoosed {
                        versionChoose()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarBackButtonHidden()
                    }
                }
                if !islogin.istrue {
                    loginPage(txtTheme: $txtTheme)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                islogin.checklog()
            }
            .environmentObject(islogin)
        }
    }
}
