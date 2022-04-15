//
//  massa.swift
//  dia
//
//  Created by Артем  on 11.09.2021.
//

import SwiftUI

struct massa: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var previewIndex = 1
    @State private var t: String = ""
    @State private var date = Date()
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var isAct: Bool = false
    @FocusState private var focusedField: Bool
    var body: some View {
        Form {
            Section(header: Text("Общая информация")){
                TextField("кг", text: $t)
                    .keyboardType(.decimalPad)
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
        .navigationTitle(Text("Измерение веса"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    let datef = DateFormatter()
                    datef.locale = Locale(identifier: "ru_RU")
                    datef.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
                    t = String(t.map {$0 == "," ? "." : $0})
                    addMassa(m: Double(t)!, time: datef.string(from: date))
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Сохранить")
                }
            }
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
        }
        .ignoresSafeArea(.keyboard)
    }
    init() {
        UIScrollView.appearance().keyboardDismissMode = .onDrag
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
}

struct massa_Previews: PreviewProvider {
    static var previews: some View {
        massa()
    }
}
