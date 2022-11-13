import SwiftUI

struct ketonur: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var t: String
    @State var date: Date
    @State var idForDelete: [Int]
    @State private var isCorrect = false
    @FocusState private var focusedField: Bool
    @Binding var hasChanged: Bool
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        List {
            Section(header: Text("Общая информация").font(.system(size: 15.5))){
                TextField("ммоль/л", text: $t)
                    .focused($focusedField)
                    .keyboardType(.decimalPad)
                DatePicker(
                    "Дата",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
            }
        }
        .navigationTitle(Text("Уровень кетонурии"))
        .navigationBarTitleDisplayMode(.inline)
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
                        addKetonur(mmol: try convert(txt: t), time: dateFormatter.string(from: date))
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        isCorrect.toggle()
                    }

                }) {
                    Text("Сохранить").dynamicTypeSize(txtTheme)
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
                    Text("Готово").dynamicTypeSize(txtTheme)
                })
            })
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            UIScrollView.appearance().keyboardDismissMode = .onDrag
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    }
}
