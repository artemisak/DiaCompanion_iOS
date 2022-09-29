import SwiftUI
import MessageUI

struct export: View {
    @Binding var txtTheme: DynamicTypeSize
    @State private var isLoad: Bool = true
    var sheets = exportTable()
    var columns: [GridItem] =
    Array(repeating: .init(.flexible()), count: 2)
    @State private var email: [String] = [""]
    @State private var erMessage: String = ""
    @State private var emailErrorMessage: Bool = false
    @EnvironmentObject var islogin: check
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    Button(action:{
                        isLoad.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                            let content = sheets.generate(version: islogin.version)
                            isLoad.toggle()
                            let AV = UIActivityViewController(activityItems: [content], applicationActivities: nil)
                            UIApplication.shared.currentUIWindow()?.rootViewController?.present(AV, animated: true, completion: nil)
                        }
                    }){
                        VStack{
                            Image("menu_xlsx")
                                .scaledToFit()
                            Text("Сохранить на устройстве")
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .buttonStyle(ChangeColorButton())
                    Button(action:{
                        email = try! findAdress()
                        if email != [""] {
                            isLoad.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                                do {
                                    let content = try Data(contentsOf: sheets.generate(version: islogin.version) as URL)
                                    isLoad.toggle()
                                    try emailSender.shared.sendEmail(subject: "DiaCompanion iOS - электронный дневник", body: "", to: email, xlsxFile: content)
                                } catch {
                                    emailErrorMessage = true
                                    erMessage = "На устройстве не установлен почтовый клиент"
                                }
                            }
                        } else {
                            emailErrorMessage = true
                            erMessage = "Перейдите в карту пациента, чтобы назначить лечащего врача. В противном случае используйте вариант сохранить на устройстве."
                        }
                    }){
                        VStack{
                            Image("menu_mail")
                                .scaledToFit()
                            Text("Отправить по почте")
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .buttonStyle(ChangeColorButton())
                    .alert("Статус операции", isPresented: $emailErrorMessage, actions: {Button(role: .cancel, action: {}, label: {Text("OK")})}, message: {Text(erMessage)})
                }
                .padding()
            }
            if !isLoad {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(2.5)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal, content: {
                Text("Экспорт данных").font(.headline).fixedSize()
            })
        }
    }
}

