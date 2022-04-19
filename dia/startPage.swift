import SwiftUI

struct startPage: View {
    @StateObject private var islogin = check()
    @State private var reg: Bool = false
    var body: some View {
        NavigationView {
            if !islogin.istrue {
                loginPage(reg: $reg, islogin: islogin)
            } else {
                mainPage()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            islogin.checklog()
        })
        .customPopupView(isPresented: $reg, popupView: { regHelper(phelper: $reg) })
    }
}

struct startPage_Previews: PreviewProvider {
    static var previews: some View {
        startPage()
    }
}
