//
//  ketonur.swift
//  dia
//
//  Created by Артем  on 10.09.2021.
//

import SwiftUI

struct ketonur: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var previewIndex = 1
    @State private var t: String = ""
    @State private var date = Date()
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var isAct: Bool = false
    var body: some View {
        Form{
            Section(header: Text("Общая информация")){
                TextField("ммоль/л", text: $t)
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
        .navigationTitle(Text("Уровень кетонурии"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(){
                Button(action: {
                    let datef = DateFormatter()
                    datef.locale = Locale(identifier: "ru_RU")
                    datef.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
                    addKetonur(mmol: Double(t)!, time: datef.string(from: date))
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

struct ketonur_Previews: PreviewProvider {
    static var previews: some View {
        ketonur()
    }
}
