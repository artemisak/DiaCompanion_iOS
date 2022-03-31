//
//  enterAct.swift
//  dia
//
//  Created by Артем  on 29.08.2021.
//

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
    @State private var actpreviewIndex = act.zar
    @FocusState private var focusedField: Bool
    var body: some View {
        Form{
            Section(header: Text("Общая информация")){
                TextField("Длительность, мин.", text: $t)
                    .keyboardType(.asciiCapableNumberPad)
                NavigationLink(destination: actPicker(actpreviewIndex: $actpreviewIndex), label: {
                    HStack{
                        Text("Род занятий")
                        Spacer()
                        Text("\(actpreviewIndex.rawValue)")
                    }
                })
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
                    addAct(min: Int(t) ?? 10, rod: actpreviewIndex.rawValue, time: dateFormatter.string(from: date))
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Сохранить")
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
                    Text("Готово")
                })
                }
            })
        })
        .ignoresSafeArea(.keyboard)
    }
    init() {
        UIScrollView.appearance().keyboardDismissMode = .onDrag
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
}

struct actPicker: View {
    @Binding var actpreviewIndex: act
    var body: some View {
        Form{
            Picker(selection: $actpreviewIndex, label: Text("Род занятий")) {
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
