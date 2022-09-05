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
    @ViewBuilder
    var body: some View {
        NavigationView {
            if !islogin.istrue {
                loginPage(islogin: islogin, txtTheme: $txtTheme)
            } else {
                mainPage(islogin: islogin, txtTheme: $txtTheme)
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            islogin.checklog()
        }
    }
}

struct startPage_Previews: PreviewProvider {
    static var previews: some View {
        startPage(txtTheme: .constant(.medium))
    }
}
