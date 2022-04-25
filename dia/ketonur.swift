import SwiftUI

struct ketonur: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var previewIndex = 1
    @State private var t: String = ""
    @State private var date = Date()
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var isAct: Bool = false
    @State private var isCorrect = false
    @FocusState private var focusedField: Bool
    var body: some View {
        List {
            Section(header: Text("Общая информация")){
                TextField("ммоль/л", text: $t)
                    .focused($focusedField)
                    .keyboardType(.decimalPad)
            }
            Section(header: Text("Время измерения")){
                VStack(alignment: .center){
                    DatePicker(
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    ){}
                        .environment(\.locale, Locale.init(identifier: "ru"))
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .clipped()
                        .compositingGroup()
                }.frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(Text("Уровень кетонурии"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    do {
                        let datef = DateFormatter()
                        datef.locale = Locale(identifier: "ru_RU")
                        datef.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
                        addKetonur(mmol: try convert(txt: t), time: datef.string(from: date))
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        isCorrect.toggle()
                    }

                }) {
                    Text("Сохранить")
                }
                .alert(isPresented: $isCorrect) {
                    Alert(title: Text("Статус операции"), message: Text("Введите релевантное \nзначение"), dismissButton: .default(Text("ОК")))
                }
            }
            ToolbarItem(placement: .keyboard, content: {
                HStack{
                    Spacer()
                    Button(action: {
                        focusedField = false
                    }, label: {
                        Text("Готово")
                    })
                }
            })
        }
        .ignoresSafeArea(.keyboard)
    }
    init() {
        UIScrollView.appearance().keyboardDismissMode = .onDrag
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
}

struct ketonur_Previews: PreviewProvider {
    static var previews: some View {
        ketonur()
    }
}
