//
//  enterAct.swift
//  dia
//
//  Created by Артем  on 29.08.2021.
//

import SwiftUI

struct enterAct: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var t: String = ""
    @State private var date = Date()
    @State var hours: Int = 0
    @State var minutes: Int = 0
    enum act: String, CaseIterable, Identifiable {
        case zar = "Зарядка"
        case sleep = "Сон"
        case hod = "Ходьба"
        case sport = "Спорт"
        case uborka = "Уборка в квартире"
        case rabota = "Работа в огороде"
        var id: String {self.rawValue}
    }
    @State private var previewIndex = act.zar
    var body: some View {
        Form{
            Section(header: Text("Общая информация")){
                TextField("Длительность, мин.", text: $t)
                    .keyboardType(.asciiCapableNumberPad)
                Picker(selection: $previewIndex, label: Text("Род занятий")) {
                    Text("Зарядка").tag(act.zar)
                    Text("Сон").tag(act.sleep)
                    Text("Ходьба").tag(act.hod)
                    Text("Спорт").tag(act.sport)
                    Text("Уборка в квартире").tag(act.uborka)
                    Text("Работа в огороде").tag(act.rabota)
                }
            }
            Section(header: Text("Время начала")){
                VStack(alignment: .center){
                DatePicker(
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                ){}
                .environment(\.locale, Locale.init(identifier: "ru"))
                .frame(width: 300)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                }.frame(maxWidth: .infinity)
            }
        }
        .navigationBarTitle(Text("Активность"))
        .toolbar {
            ToolbarItemGroup(){
                Button(action: {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "ru_RU")
                    dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
                    addAct(min: Int(t) ?? 10, rod: previewIndex.rawValue, time: dateFormatter.string(from: date))
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Сохранить")
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    init() {
        UIScrollView.appearance().keyboardDismissMode = .onDrag
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
}

struct enterAct_Previews: PreviewProvider {
    static var previews: some View {
        enterAct()
    }
}
