//
//  inject.swift
//  dia
//
//  Created by Артем  on 31.08.2021.
//

import SwiftUI

struct inject: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var t: String = ""
    @State private var date = Date()
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var isAct: Bool = false
    enum inject :String, CaseIterable, Identifiable {
        case natoshak = "Натощак"
        case zavtrak = "Завтрак"
        case obed = "Обед"
        case uzin = "Ужин"
        case dop = "Дополнительно"
        var id: String { self.rawValue }
    }
    @State private var previewIndex1 = inject.natoshak
    enum injectType: String, CaseIterable, Identifiable {
        case ultra = "Ультракоторкий"
        case kor = "Короткий"
        case prolong = "Пролонгированный"
        var id: String { self.rawValue }
    }
    @State private var previewIndex = injectType.ultra
    var body: some View {
        Form{
            Section(header: Text("Общая информация")){
                TextField("Ед.", text: $t)
                    .keyboardType(.decimalPad)
                Picker("Тип действия", selection: $previewIndex) {
                    Text("Ультракороткий").tag(injectType.ultra)
                    Text("Короткий").tag(injectType.kor)
                    Text("Пролонгированный").tag(injectType.prolong)
                }
                Picker("Прием пищи", selection: $previewIndex1) {
                    Text("Натощак").tag(inject.natoshak)
                    Text("Завтрак").tag(inject.zavtrak)
                    Text("Обед").tag(inject.obed)
                    Text("Ужин").tag(inject.uzin)
                    Text("Дополнительно").tag(inject.dop)
                }
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
        .navigationBarTitle(Text("Введение инсулина"))
        .toolbar {
            ToolbarItemGroup(){
                Button(action: {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "ru_RU")
                    dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
                    t = String(t.map {$0 == "," ? "." : $0})
                    addInject(ed: Double(t) ?? 5.0, type: previewIndex.rawValue, priem: previewIndex1.rawValue, time: dateFormatter.string(from: date))
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

struct inject_Previews: PreviewProvider {
    static var previews: some View {
        inject()
    }
}
