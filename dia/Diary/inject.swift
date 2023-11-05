import SwiftUI

enum injects :String, CaseIterable, Identifiable {
    case natoshak = "Натощак"
    case zavtrak = "Завтрак"
    case obed = "Обед"
    case uzin = "Ужин"
    case dop = "Дополнительно"
    var id: String { self.rawValue }
}

enum injectType: String, CaseIterable, Identifiable {
    case ultra = "Ультракороткий"
    case kor = "Короткий"
    case prolong = "Пролонгированный"
    var id: String { self.rawValue }
}

struct inject: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var t : String
    @State var date : Date
    @State var previewIndex : injectType
    @State var previewIndex1 : injects
    @State var idForDelete: [Int]
    @State private var isCorrect: Bool = false
    @Binding var hasChanged: Bool
    var body: some View {
        List {
            Section(header: Text("Общая информация").font(.body)){
                TextField("Ед.", text: $t)
                    .keyboardType(.decimalPad)
                NavigationLink(destination: injectTypePicker(previewIndex: $previewIndex), label: {
                    HStack{
                        Text("Тип действия")
                        Spacer()
                        Text(LocalizedStringKey(previewIndex.rawValue))
                            .foregroundColor(.gray)
                    }
                })
                NavigationLink(destination: injectPicker(previewIndex1: $previewIndex1), label: {
                    HStack{
                        Text("Прием пищи")
                        Spacer()
                        Text(LocalizedStringKey(previewIndex1.rawValue))
                            .foregroundColor(.gray)
                    }
                })
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
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toolbar {
            ToolbarItemGroup(){
                Button(action: {
                    do {
                        if !idForDelete.isEmpty {
                            deleteFromBD(idToDelete: idForDelete, table: 2)
                            hasChanged = true
                        }
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
                        patientManager.provider.addInject(ed: try convert(txt: t), type: previewIndex.rawValue, priem: previewIndex1.rawValue, time: dateFormatter.string(from: date))
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        isCorrect = true
                    }
                }) {
                    Text("Сохранить")
                }
                .alert(isPresented: $isCorrect) {
                    Alert(title: Text("Статус операции"), message: Text(LocalizedStringKey("Введите релевантное значение")), dismissButton: .default(Text("ОК")))
                }
            }
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button(action: {
                    UIApplication.shared.dismissedKeyboard()
                }, label: {
                    Text("Готово")
                })
            })
        }
        .navigationTitle("Инсулин")
    }
}


struct injectTypePicker: View {
    @Binding var previewIndex: injectType
    var body: some View {
        List {
            Picker(selection: $previewIndex, label: Text("Тип действия").font(.body)) {
                Text(LocalizedStringKey("Ультракороткий")).tag(injectType.ultra)
                Text(LocalizedStringKey("Короткий")).tag(injectType.kor)
                Text(LocalizedStringKey("Пролонгированный")).tag(injectType.prolong)
            }.pickerStyle(.inline)
        }
    }
}

struct injectPicker: View {
    @Binding var previewIndex1: injects
    var body: some View {
        List {
            Picker(selection: $previewIndex1, label: Text("Прием пищи").font(.body)) {
                Text(LocalizedStringKey("Натощак")).tag(injects.natoshak)
                Text(LocalizedStringKey("Завтрак")).tag(injects.zavtrak)
                Text(LocalizedStringKey("Обед")).tag(injects.obed)
                Text(LocalizedStringKey("Ужин")).tag(injects.uzin)
                Text(LocalizedStringKey("Дополнительно")).tag(injects.dop)
            }.pickerStyle(.inline)
        }
    }
}
