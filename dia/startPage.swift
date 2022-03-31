//
//  startPage.swift
//  dia
//
//  Created by Артём Исаков on 17.02.2022.
//

import SwiftUI

struct startPage: View {
    @StateObject private var islogin = check()
    var body: some View {
        NavigationView {
            if !islogin.istrue {
                loginPage(islogin: islogin)
            } else {
                mainPage()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .task {
            await islogin.checklog()
        }
    }
}

struct startPage_Previews: PreviewProvider {
    static var previews: some View {
        startPage()
    }
}
