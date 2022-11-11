import SwiftUI

struct dStart: View {
    @Binding var bStart: Bool
    @Binding var vDate: Date
    var body: some View {
        ZStack{
            Color.black.opacity(0.2).ignoresSafeArea()
            VStack(spacing: 0){
                Text("Дата начала ведения дневника")
                    .padding()
                Divider()
                DatePicker(
                    "Дата",
                    selection: $vDate,
                    displayedComponents: [.date]
                )
                .environment(\.locale, Locale.init(identifier: "ru"))
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(width: UIScreen.main.bounds.width-30)
                .clipped()
                .compositingGroup()
                Divider()
                HStack(){
                    Button(action: {
                        vDate = Date.now
                        bStart.toggle()
                    }){
                        Text("Отменить")
                    }.buttonStyle(TransparentButton())
                    Divider()
                    Button(action: {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ru_RU")
                        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
                        addDateS(pDate: dateFormatter.string(from: vDate))
                        vDate = Date.now
                        bStart.toggle()
                    }){
                        Text("Сохранить")
                    }.buttonStyle(TransparentButton())
                }.frame(height: 50)
            }
            .background(Color.white.cornerRadius(10))
            .padding([.leading, .trailing], 15)
        }
        .onAppear {
            vDate = getPreloadStartDate()
        }
    }
}
