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
        NavigationView {
            if islogin.istrue {
                if islogin.isChoosed {
                    mainPage(txtTheme: $txtTheme)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("ДиаКомпаньон")
                        .navigationBarBackButtonHidden(true)
                        .navigationViewStyle(StackNavigationViewStyle())
                } else {
                    versionChoose()
                        .navigationBarTitleDisplayMode(.large)
                        .navigationTitle("Профилирование")
                        .navigationBarBackButtonHidden()
                        .navigationViewStyle(StackNavigationViewStyle())
                }
            } else {
                loginPage(txtTheme: $txtTheme)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden()
                    .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .onAppear {
            islogin.checklog()
        }
        .environmentObject(islogin)
    }
}
