import SwiftUI

enum act: String, CaseIterable, Identifiable {
    case zar = "Зарядка"
    case sleep = "Сон"
    case hod = "Ходьба"
    case sport = "Спорт"
    case uborka = "Уборка в квартире"
    case rabota = "Работа в огороде"
    var id: String {self.rawValue}
}

struct enterAct: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var t: String
    @State var date: Date
    @State var actpreviewIndex: act
    @State var idForDelete: [Int]
    @State private var isCorrect: Bool = false
    @FocusState private var focusedField: Bool
    @Binding var hasChanged: Bool
    var body: some View {
        List {
            Section(header: Text("Общая информация").font(.caption)){
                TextField("Длительность, мин.", text: $t)
                    .keyboardType(.numberPad)
                    .focused($focusedField)
                NavigationLink(destination: actPicker(actpreviewIndex: $actpreviewIndex), label: {
                    HStack{
                        Text("Род занятий")
                        Spacer()
                        Text("\(actpreviewIndex.rawValue)")
                    }
                })
                DatePicker(
                    "Дата",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
            }
        }
        .navigationTitle("Aктивность")
        .toolbar {
            ToolbarItemGroup(){
                Button(action: {
                    do {
                        if !idForDelete.isEmpty {
                            deleteFromBD(idToDelete: idForDelete, table: 1)
                            hasChanged = true
                        }
                        let intT = try convertToInt(txt: t)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
                        pacientManager.provider.addAct(min: intT, rod: actpreviewIndex.rawValue, time: dateFormatter.string(from: date))
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        isCorrect = true
                    }
                }) {
                    Text("Сохранить")
                }
                .alert(isPresented: $isCorrect) {
                    Alert(title: Text("Статус операции"), message: Text("Введите релевантное \nзначение"), dismissButton: .default(Text("ОК")))
                }
            }
        }
        .toolbar(content: {
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button(action: {
                    focusedField = false
                }, label: {
                    Text("Готово")
                })
            })
        })
        .ignoresSafeArea(.keyboard)
        .onAppear(perform: {
            UIScrollView.appearance().keyboardDismissMode = .onDrag
            UITableView.appearance().showsVerticalScrollIndicator = false
        })
    }
}

struct actPicker: View {
    @Binding var actpreviewIndex: act
    var body: some View {
        Form{
            Picker(selection: $actpreviewIndex, label: Text("Род занятий").font(.caption)) {
                Text("Зарядка").tag(act.zar)
                Text("Сон").tag(act.sleep)
                Text("Ходьба").tag(act.hod)
                Text("Спорт").tag(act.sport)
                Text("Уборка в квартире").tag(act.uborka)
                Text("Работа в огороде").tag(act.rabota)
            }.pickerStyle(.inline)
        }
    }
}
