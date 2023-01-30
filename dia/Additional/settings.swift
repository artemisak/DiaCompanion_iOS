import SwiftUI
import PDFKit

struct settings: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var fileUrl = Bundle.main.url(forResource: "Education", withExtension: "pdf")!
    @State private var phelper : Bool = false
    @State private var eraseAccount = false
    @State private var eraseDB = false
    @State private var eraseDBprogress = false
    @State private var arrowAngle = 0.0
    @EnvironmentObject var routeManager: Router
    var body: some View {
        List {
            Section(header: Text("Карта пациента").font(.caption)){
                NavigationLink(destination: pacientCart()) {
                    Button("Данные пациента", action: {})
                }.foregroundColor(Color("listButtonColor"))
                NavigationLink(destination: severalDatesPicker()) {
                    Button("Отметить полные дни", action: {})
                }.foregroundColor(Color("listButtonColor"))
                NavigationLink(destination: PDFKitView(url: fileUrl).ignoresSafeArea(.all, edges: .bottom).navigationTitle("Обучение").navigationBarTitleDisplayMode(.inline)) {
                    Button("Обучение", action: {})
                }.foregroundColor(Color("listButtonColor"))
                NavigationLink(destination: helper(phelper: $phelper)) {
                    Button("Помощь", action: {})
                }.foregroundColor(Color("listButtonColor"))
                NavigationLink(destination: aboutApp()){
                    Button("О приложении", action: {})
                }.foregroundColor(Color("listButtonColor"))
            }
            Section(header: Text("Параметры восстановления").font(.caption)){
                Button {
                    eraseDB = true
                } label: {
                    HStack{
                        if eraseDBprogress {
                            ProgressView().frame(width: 22.5)
                        } else {
                            Image(systemName: "arrow.clockwise").frame(width: 22.5)
                        }
                        Text("Восстановить базу данных").padding(.leading)
                        Spacer()
                    }.foregroundColor(Color.accentColor)
                }
                .confirmationDialog("Восстановление подразумевает отмену всех вносимых в вами в базу данных имзенений.", isPresented: $eraseDB, titleVisibility: .visible, actions: {
                    Button("ОК", action: {
                        eraseDBprogress = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {eraseDBprogress = restoreDB()})
                    })
                })
            }
            Section(header: Text("Управление аккаунтом").font(.caption)) {
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
                        Task {
                            await pacientManager.provider.deleteAccaunt()
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
