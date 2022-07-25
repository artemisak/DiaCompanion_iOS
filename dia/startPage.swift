import SwiftUI

struct startPage: View {
    @StateObject private var islogin = check()
    @State private var reg: Bool = false
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        NavigationView {
            if !islogin.istrue {
                loginPage(reg: $reg, txtTheme: $txtTheme, islogin: islogin)
            } else {
                mainPage(txtTheme: $txtTheme)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .task {
            islogin.checklog()
        }
        .customPopupView(isPresented: $reg, popupView: { regHelper(phelper: $reg) })
    }
}
