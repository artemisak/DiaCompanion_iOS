import SwiftUI

struct bday: View {
    @Binding var pDate: Bool
    @Binding var vDate: Date
    var body: some View {
        ZStack{
            Color("Popup_Background").ignoresSafeArea()
            VStack(spacing: 0){
                Text("Дата рождения")
                    .padding()
                Divider()
                DatePicker(
                    "Дата",
                    selection: $vDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.locale, Locale.init(identifier: "ru"))
                .padding([.top, .bottom])
                .frame(width: UIScreen.main.bounds.width-30)
                .clipped()
                .compositingGroup()
                Divider()
                HStack(){
                    Button(action: {
                        vDate = Date.now
                        pDate.toggle()
                    }){
                        Text("Отменить")
                    }.buttonStyle(TransparentButton())
                    Divider()
                    Button(action: {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ru_RU")
                        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
                        pacientManager.provider.addDate(pDate: dateFormatter.string(from: vDate))
                        vDate = Date.now
                        pDate.toggle()
                    }){
                        Text("Сохранить")
                    }.buttonStyle(TransparentButton())
                }.frame(height: 50)
            }
            .background(Color("Popup_Field").cornerRadius(10))
            .padding([.leading, .trailing], 15)
        }
        .onAppear(perform: {
            vDate = pacientManager.provider.getPreloadBD()
        })
    }
}

