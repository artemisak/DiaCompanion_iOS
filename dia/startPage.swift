//
//  startPage.swift
//  dia
//
//  Created by Артём Исаков on 17.02.2022.
//

import SwiftUI

struct startPage: View {
    @StateObject var islogin = check()
    var body: some View {
        NavigationView {
            if !islogin.istrue {
                loginPage(islogin: islogin)
            } else {
                mainPage()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            islogin.checklog()
        })
    }
}


struct startPage_Previews: PreviewProvider {
    static var previews: some View {
        startPage()
    }
}
