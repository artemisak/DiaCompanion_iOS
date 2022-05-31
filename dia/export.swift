import SwiftUI
import MessageUI

struct export: View {
    @State private var isLoad: Bool = true
    var sheets = exportTable()
    var columns: [GridItem] =
    Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    Button(action:{
                        isLoad.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                            isLoad.toggle()
                            let AV = UIActivityViewController(activityItems: [sheets.generate()], applicationActivities: nil)
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
                        isLoad.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                            do {
                                isLoad.toggle()
                                emailSender.shared.sendEmail(subject: "Электронный дневник", body: "", to: "amedi.ioakim@gmail.com", xlsxFile: try Data(contentsOf: sheets.generate()))
                            } catch {
                                print(error)
                            }
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
                }
                .padding()
            }
            if !isLoad {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(2.5)
            }
        }
        .navigationTitle("Экспорт данных")
    }
}

struct export_Previews: PreviewProvider {
    static var previews: some View {
        export()
    }
}

