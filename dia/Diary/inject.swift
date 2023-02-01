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
    case ultra = "Ультракоторкий"
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
            Section(header: Text("Общая информация").font(.caption)){
                TextField("Ед.", text: $t)
                    .keyboardType(.decimalPad)
                NavigationLink(destination: injectTypePicker(previewIndex: $previewIndex), label: {
                    HStack{
                        Text("Тип действия")
                        Spacer()
                        Text("\(previewIndex.rawValue)")
                            .foregroundColor(.gray)
                    }
                })
                NavigationLink(destination: injectPicker(previewIndex1: $previewIndex1), label: {
                    HStack{
                        Text("Прием пищи")
                        Spacer()
                        Text("\(previewIndex1.rawValue)")
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
                        pacientManager.provider.addInject(ed: try convert(txt: t), type: previewIndex.rawValue, priem: previewIndex1.rawValue, time: dateFormatter.string(from: date))
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
            Picker(selection: $previewIndex, label: Text("Тип действия").font(.caption)) {
                Text("Ультракороткий").tag(injectType.ultra)
                Text("Короткий").tag(injectType.kor)
                Text("Пролонгированный").tag(injectType.prolong)
            }.pickerStyle(.inline)
        }
    }
}

struct injectPicker: View {
    @Binding var previewIndex1: injects
    var body: some View {
        List {
            Picker(selection: $previewIndex1, label: Text("Прием пищи").font(.caption)) {
                Text("Натощак").tag(injects.natoshak)
                Text("Завтрак").tag(injects.zavtrak)
                Text("Обед").tag(injects.obed)
                Text("Ужин").tag(injects.uzin)
                Text("Дополнительно").tag(injects.dop)
            }.pickerStyle(.inline)
        }
    }
}

struct inject_Previews: PreviewProvider {
    static var previews: some View {
        inject(t: "", date: Date.now, previewIndex: .prolong, previewIndex1: .dop, idForDelete: [], hasChanged: .constant(false))
    }
}
