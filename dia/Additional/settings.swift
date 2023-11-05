import SwiftUI
import PDFKit

struct settings: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var routeManager: Router
    @State private var fileUrl = Bundle.main.url(forResource: "Education", withExtension: "pdf")!
    @State private var phelper : Bool = false
    @State private var eraseAccount = false
    @State private var arrowAngle = 0.0
    var body: some View {
        List {
            Section(header: Text("Карта пациента").font(.body)){
                NavigationLink(destination: {
                    if #available(iOS 16, *){
                        patientCart()
                            .toolbar(.hidden, for: .tabBar)
                    } else {
                        patientCart().hiddenTabBar()
                    }
                }) {Text("О пациенте")}.foregroundColor(Color("listButtonColor"))
                NavigationLink(destination: {
                    if #available(iOS 16, *){
                        severalDatesPicker().toolbar(.hidden, for: .tabBar)
                    } else {
                        severalDatesPicker().hiddenTabBar()
                    }
                }) {Text("Полные дни")}.foregroundColor(Color("listButtonColor"))
                NavigationLink(destination: {
                    if #available(iOS 16, *){
                        PDFKitView(url: fileUrl).ignoresSafeArea(.all, edges: .bottom).navigationTitle("Обучение").navigationBarTitleDisplayMode(.inline).toolbar(.hidden, for: .tabBar)
                    } else {
                        PDFKitView(url: fileUrl).ignoresSafeArea(.all, edges: .bottom).navigationTitle("Обучение").navigationBarTitleDisplayMode(.inline).hiddenTabBar()
                    }
                }) {Text("Обучение")}.foregroundColor(Color("listButtonColor"))
                NavigationLink(destination: {
                    if #available(iOS 16, *){
                        helper(phelper: $phelper).toolbar(.hidden, for: .tabBar)
                    } else {
                        helper(phelper: $phelper).hiddenTabBar()
                    }
                }) {Text("Контакты")}.foregroundColor(Color("listButtonColor"))
                NavigationLink(destination: {
                    if #available(iOS 16, *){
                        aboutApp().toolbar(.hidden, for: .tabBar)
                    } else {
                        aboutApp().hiddenTabBar()
                    }
                }){Text("О приложении")}.foregroundColor(Color("listButtonColor"))
            }
            Section(header: Text("Управление аккаунтом").font(.body)) {
                Button(action: {
                    eraseAccount = true
                }, label: {
                    HStack{
                        Image(systemName: "trash.fill")
                        Text("Удалить аккаунт").padding(.leading)
                        Spacer()
                    }.foregroundColor(Color.red)
                }).confirmationDialog("Удаляя аккаунт вы потеряете доступ к приложению, вся информация в нем будет удалена.", isPresented: $eraseAccount, titleVisibility: .visible, actions: {
                    Button("ОК", action: {
                        presentationMode.wrappedValue.dismiss()
                        routeManager.isLoggedIn = false
                        routeManager.isChoosed = false
                        routeManager.version = 1
                        routeManager.tabViewStatment = 1
                        Task {
                            await patientManager.provider.deleteAccaunt()
                        }
                    })
                })
            }
        }
        .listStyle(.insetGrouped)
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Дополнительно")
    }
}
