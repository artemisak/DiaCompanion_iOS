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
    @State private var t: String = ""
    @State private var date = Date()
    @State private var isCorrect: Bool = false
    @State private var actpreviewIndex = act.zar
    @FocusState private var focusedField: Bool
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        List {
            Section(header: Text("Общая информация").font(.system(size: 15.5))){
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
            }
            Section(header: Text("Время начала").font(.system(size: 15.5))){
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
        .navigationTitle("Aктивность")
        .toolbar {
            ToolbarItemGroup(){
                Button(action: {
                    do {
                        let intT = try convertToInt(txt: t)
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ru_RU")
                        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
                        addAct(min: intT, rod: actpreviewIndex.rawValue, time: dateFormatter.string(from: date))
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        isCorrect = true
//                        let alertController = UIAlertController(title: "Статус операции", message: "Введите ненулевое \nзначение", preferredStyle: UIAlertController.Style.alert)
//                        alertController.overrideUserInterfaceStyle = .light
//                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
//                            (result : UIAlertAction) -> Void in
//                        }
//                        alertController.addAction(okAction)
//                        UIApplication.shared.currentUIWindow()?.rootViewController?.present(alertController, animated: true, completion: nil)
                    }
                }) {
                    Text("Сохранить").dynamicTypeSize(txtTheme)
                }
                .alert(isPresented: $isCorrect) {
                    Alert(title: Text("Статус операции"), message: Text("Введите релевантное \nзначение"), dismissButton: .default(Text("ОК")))
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .keyboard, content: {
                HStack{
                    Spacer()
                    Button(action: {
                        focusedField = false
                    }, label: {
                        Text("Готово").dynamicTypeSize(txtTheme)
                    })
                }
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
            Picker(selection: $actpreviewIndex, label: Text("Род занятий").font(.system(size: 15.5))) {
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
