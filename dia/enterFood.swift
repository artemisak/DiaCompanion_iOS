//
//  page3.swift
//  dia
//
//  Created by Артем  on 22.08.2021.
//

import SwiftUI

struct enterFood: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var multiSelection = Set<UUID>()
    @State private var previewIndex = 1
    @State private var enabled : Bool = false
    @State private var sugar: String = ""
    @State private var isEditing = false
    @State private var sugarlvl: String = "Риск не определен"
    @State private var isHidden: Bool = true
    @State private var date = Date()
    @State private var foodn: String = ""
    @State private var i: Int = 0
    @State private var isSheetShown = false
    @State public var foodItems: [String] = []
    
    var body: some View {
        Form {
            Section(header: Text("Общая информация")){
                Picker(selection: $previewIndex, label: Text("Прием пищи")) {
                    Text("Завтрак").tag(1)
                    Text("Обед").tag(2)
                    Text("Ужин").tag(3)
                    Text("Перекусы").tag(4)
                }
                DatePicker(
                    "Дата",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                ).environment(\.locale, Locale.init(identifier: "ru"))
            }
            Section(header: Text("Уровень сахара в крови")) {
                Toggle(isOn: $enabled) {Text("Записать текущий УСК")}
                .onChange(of: enabled){_ in
                    sugar = ""
                    sugarlvl = "УСК не определен"
                }
            }
            Section {
                Text("\(sugarlvl)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                TextField("5,0 ммоль/л", text: $sugar)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .keyboardType(.decimalPad)
                    .disabled(enabled == false)
                    .onChange(of: sugar){_ in
                        if (sugar == ""){
                            sugarlvl = "Риск не определен"
                        } else if (Double(sugar) ?? 5.0 > 7){
                            sugarlvl = "УСК превысит норму"
                        } else {
                            sugarlvl = "УСК в норме"
                        }
                    }
            }
            Section(header: Text("Потребленные продукты")){
                Button(action:{
                    isSheetShown.toggle()
                }, label:{
                    HStack{
                        Text("Добавить")
                        Image(systemName: "folder.badge.plus")
                    }
                })
                    .sheet(isPresented: $isSheetShown){
                        addFoodButton(foodItems: $foodItems)
                    }
            }
            Section(){
                ForEach(foodItems, id: \.self) {
                    Text($0)
                }
                .onDelete(perform: removeRows)
            }
        }
        
        .navigationTitle("Приемы пищи")
        .toolbar {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Сохранить")
            }
        }
    }
    func removeRows(at offsets: IndexSet){
        foodItems.remove(atOffsets: offsets)
    }
}

//struct enterFood_Previews: PreviewProvider {
//    static var previews: some View {
//        enterFood()
//    }
//}
