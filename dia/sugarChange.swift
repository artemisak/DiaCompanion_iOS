//
//  sugarChange.swift
//  dia
//
//  Created by Артем  on 31.08.2021.
//

import SwiftUI

struct sugarChange: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var t: String = ""
    @State private var date = Date()
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var isAct: Bool = false
    @State private var bool1: Int = 0
    enum selectedvar: String, CaseIterable, Identifiable {
        case natoshak = "Натощак"
        case zavtrak = "После завтрака"
        case obed = "После обеда"
        case uzin = "После ужина"
        case dop = "Дополнительно"
        case rodi = "При родах"
        var id: String { self.rawValue }
    }
    @State private var previewIndex = selectedvar.natoshak
    var body: some View {
        Form {
            Section(header: Text("Общая информация")){
                TextField("Уровень сахара в крови, ммоль/л", text: $t)
                    .keyboardType(.decimalPad)
                Picker("Период", selection: $previewIndex) {
                    Text("Натощак").tag(selectedvar.natoshak)
                    Text("После завтрака").tag(selectedvar.zavtrak)
                    Text("После обеда").tag(selectedvar.obed)
                    Text("После ужина").tag(selectedvar.uzin)
                    Text("Дополнительно").tag(selectedvar.dop)
                    Text("При родах").tag(selectedvar.rodi)
                }
                Toggle(isOn: $isAct, label: {
                    Text("Была физическая нагрузка")
                })
            }
            Section(header: Text("Время измерения")){
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
        .navigationBarTitle(Text("Измерение сахара"))
        .toolbar {
            ToolbarItemGroup(){
                Button(action: {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "ru_RU")
                    dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
                    if isAct {
                        bool1 = 1
                    } else {
                        bool1 = 0
                    }
                    t = String(t.map {
                        $0 == "," ? "." : $0
                    })
                    addSugarChange(lvl: Double(t) ?? 5.0, period: previewIndex.rawValue, physical: bool1, time: dateFormatter.string(from: date))
                    self.presentationMode.wrappedValue.dismiss()
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

//struct sugarChange_Previews: PreviewProvider {
//    static var previews: some View {
//        sugarChange()
//    }
//}
