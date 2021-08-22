//
//  page21.swift
//  dia
//
//  Created by Артем  on 22.08.2021.
//

import SwiftUI

struct page2: View {
    @State private var username: String = ""
    @State private var isEditing = false
    @State private var h: CGFloat = 145
    @State private var visible: Bool = true
    @State private var visibleB: Bool = true
    @State private var enabled : Bool = false
    @State private var selected = ["Завтрак","Обед","Ужин","Перекус"]
    @State private var previewIndex = 1
    @State private var sugar: String = ""
    @State private var sugarlvl: String = ""
    @State private var date = Date()
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2021, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    let numf = NumberFormatter()
    var body: some View {
        Form {
            Section(header: Text("общая информация")) {
                Picker(selection: $previewIndex, label: Text("Прием пищи")) {
                    Text("Завтрак").tag(1)
                    Text("Обед").tag(2)
                    Text("Ужин").tag(3)
                    Text("Перекусы").tag(4)
                }
                DatePicker(
                    "Дата",
                     selection: $date,
                     in: dateRange,
                     displayedComponents: [.date, .hourAndMinute]
                )
            }
            Section(header: Text("потребленные продукты")) {
                VStack(spacing: 0) {
                    Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                       Text("\(sugarlvl)").frame(maxWidth: .infinity).frame(minHeight: 25)
                    }.background(Color.green).foregroundColor(Color.white).cornerRadius(8).disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).isHidden(visible, remove: true).padding(.bottom)
                    LazyVStack(){
                        ScrollView {
                            LazyVStack(alignment: .leading) {
                                ForEach(0..<10) {
                                    Text("Блюдо \($0+1)")
                                }
                            }.frame(maxWidth: .infinity)
                        }.frame(maxHeight: h).isHidden(visibleB, remove: true).padding(.bottom)
                    }
                    Button(action: {
                            h = 146
                            visibleB = false
                            visible = true
                            sugar = ""
                            enabled = false}){
                        Text("+")
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                    }.frame(minHeight: 50, maxHeight: .infinity).buttonStyle(filledButton())
                }.frame(height: 215).padding(.vertical)
            }
            Section(header: Text("Уровень сахара в крови")) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Записать текущий УСК")
                        
                        Toggle(isOn: $enabled) {}.labelsHidden()
                    }.padding(.top)
                    GroupBox() {
                        TextField("ммоль/л", text: $sugar) { isEditing in
                            self.isEditing = isEditing
                        } onCommit: {
                            h = 125
                            visible = false
                            let a: String = $sugar.wrappedValue
                            var b: [String] = [""]
                            var bc: Int
                            b = a.components(separatedBy: ",")
                            bc = b.count
                            if bc == 2 {
                                b = [b[0] + "." + b[1]]
                            } else {
                                b = [b[0]]
                            }
                            if Double(b[0])! <= 7 {
                                sugarlvl = "УСК в норме"
                            } else {
                                sugarlvl = "УСК превысит норму"
                            }
                        }
                            .disabled(enabled ? false : true)
                    }.padding(.bottom)
                }
            }
        }
        .navigationBarTitle(Text("Приемы пищи"))
        .toolbar {
            ToolbarItemGroup(){
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Сохранить")
                }
            }
        }
    }
}

struct page2_Previews: PreviewProvider {
    static var previews: some View {
        page2()
    }
}
