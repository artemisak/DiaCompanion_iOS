import SwiftUI

enum selectedvar: String, CaseIterable, Identifiable {
    case natoshak = "Натощак"
    case zavtrak = "После завтрака"
    case obed = "После обеда"
    case uzin = "После ужина"
    case dop = "Дополнительно"
    case rodi = "При родах"
    var id: String { self.rawValue }
}

struct sugarChange: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var t: String = ""
    @State private var date = Date()
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var isAct: Bool = false
    @State private var bool1: Int = 0
    @State private var isCorrect: Bool = false
    @State private var spreviewIndex = selectedvar.natoshak
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        List {
            Section(header: Text("Общая информация").font(.system(size: 15.5))){
                TextField("Уровень сахара в крови, ммоль/л", text: $t)
                    .keyboardType(.decimalPad)
                NavigationLink(destination: sugarPicker(spreviewIndex: $spreviewIndex), label: {
                    HStack {
                        Text("Период")
                        Spacer()
                        Text("\(spreviewIndex.rawValue)")
                            .foregroundColor(.gray)
                    }
                })
                Toggle(isOn: $isAct, label: {
                    Text("Физическая нагрузка")
                })
            }
            Section(header: Text("Время измерения").font(.system(size: 15.5))){
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
        .navigationTitle("Измерение сахара")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    do {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ru_RU")
                        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
                        if isAct {
                            bool1 = 1
                        } else {
                            bool1 = 0
                        }
                        addSugarChange(lvl: try convert(txt: t), period: spreviewIndex.rawValue, physical: bool1, time: dateFormatter.string(from: date))
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        isCorrect = true
//                        let alertController = UIAlertController(title: "Статус операции", message: "Введите релевантное \nзначение", preferredStyle: UIAlertController.Style.alert)
//                        alertController.overrideUserInterfaceStyle = .light
//                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
//                            (result : UIAlertAction) -> Void in
//                        }
//                        alertController.addAction(okAction)
//                        UIApplication.shared.currentUIWindow()?.rootViewController?.present(alertController, animated: true, completion: nil)
                    }
                }) {
                    Text("Сохранить")
                        .dynamicTypeSize(txtTheme)
                }
                .alert(isPresented: $isCorrect) {
                    Alert(title: Text("Статус операции"), message: Text("Введите релевантное \nзначение"), dismissButton: .default(Text("ОК")))
                }
            })
            ToolbarItem(placement: .keyboard, content: {
                HStack{
                    Spacer()
                    Button(action: {
                        UIApplication.shared.dismissedKeyboard()
                    }, label: {
                        Text("Готово").dynamicTypeSize(txtTheme)
                    })
                }
            })
        }
        .ignoresSafeArea(.keyboard)
        .onAppear(perform: {
            UIScrollView.appearance().keyboardDismissMode = .onDrag
            UITableView.appearance().showsVerticalScrollIndicator = false
        })
    }
}

struct sugarPicker: View {
    @Binding var spreviewIndex: selectedvar
    var body: some View {
        Form {
            Picker(selection: $spreviewIndex , label: Text("Период").font(.system(size: 15.5))) {
                Text("Натощак").tag(selectedvar.natoshak)
                Text("После завтрака").tag(selectedvar.zavtrak)
                Text("После обеда").tag(selectedvar.obed)
                Text("После ужина").tag(selectedvar.uzin)
                Text("Дополнительно").tag(selectedvar.dop)
                Text("При родах").tag(selectedvar.rodi)
            }.pickerStyle(.inline)
        }
    }
}
