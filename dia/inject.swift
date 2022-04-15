//
//  inject.swift
//  dia
//
//  Created by Артем  on 31.08.2021.
//

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
    @State private var t: String = ""
    @State private var date = Date()
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var isAct: Bool = false
    @State private var previewIndex1 = injects.natoshak
    @State private var previewIndex = injectType.ultra
    var body: some View {
        Form {
            Section(header: Text("Общая информация")){
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
        .toolbar(content: {
            ToolbarItem(placement: .keyboard, content: {
                HStack{
                    Spacer()
                    Button(action: {
                        UIApplication.shared.dismissedKeyboard()
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

struct injectTypePicker: View {
    @Binding var previewIndex: injectType
    var body: some View {
        Form {
            Picker("Тип действия", selection: $previewIndex) {
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
        Form {
            Picker("Прием пищи", selection: $previewIndex1) {
                Text("Натощак").tag(injects.natoshak)
                Text("Завтрак").tag(injects.zavtrak)
                Text("Обед").tag(injects.obed)
                Text("Ужин").tag(injects.uzin)
                Text("Дополнительно").tag(injects.dop)
            }.pickerStyle(.inline)
        }
    }
}
