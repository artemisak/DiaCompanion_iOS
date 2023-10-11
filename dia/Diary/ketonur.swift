import SwiftUI

struct ketonur: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var t: String
    @State var date: Date
    @State var idForDelete: [Int]
    @State private var isCorrect = false
    @FocusState private var focusedField: Bool
    @Binding var hasChanged: Bool
    var body: some View {
        List {
            Section(header: Text("Общая информация").font(.caption)){
                TextField("ммоль/л", text: $t)
                    .focused($focusedField)
                    .keyboardType(.decimalPad)
                DatePicker(
                    "Дата",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .onAppear {
                    if idForDelete.isEmpty {date = Date()}
                }
            }
        }
        .navigationTitle(Text("Кетонурия"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    do {
                        if !idForDelete.isEmpty {
                            deleteFromBD(idToDelete: idForDelete, table: 4)
                            hasChanged = true
                        }
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
                        patientManager.provider.addKetonur(mmol: try convert(txt: t), time: dateFormatter.string(from: date))
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
        }
        .toolbar{
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button(action: {
                    focusedField = false
                }, label: {
                    Text("Готово")
                })
            })
        }
        .ignoresSafeArea(.keyboard)
    }
}
