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
    @State private var enabled : Bool = false
    @State private var sugar: String = ""
    @State private var isEditing = false
    @State private var sugarlvl: String = "УСК не определен"
    @State private var isHidden: Bool = true
    @State private var date = Date()
    @State private var foodn: String = ""
    @State private var i: Int = 0
    @State private var isSheetShown = false
    @State public var foodItems: [String] = []
    enum ftype: String, CaseIterable, Identifiable {
        case zavtrak = "Завтрак"
        case obed = "Обед"
        case uzin = "Ужин"
        case perekus = "Перекусы"
        var id: String { self.rawValue }
    }
    @State private var previewIndex = ftype.zavtrak
    var body: some View {
        Form {
            Section(header: Text("Общая информация")){
                Picker(selection: $previewIndex, label: Text("Прием пищи")) {
                    Text("Завтрак").tag(ftype.zavtrak)
                    Text("Обед").tag(ftype.obed)
                    Text("Ужин").tag(ftype.uzin)
                    Text("Перекусы").tag(ftype.perekus)
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
                            sugarlvl = "УСК не определен"
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
                    .sheet(isPresented: $isSheetShown) {
                        addFoodButton(foodItems: $foodItems)
                    }
            }
            Section(){
                ForEach(foodItems, id: \.self) {i in
                    let arg = "\(i)".components(separatedBy: "//")
                    Text("\(arg[0]), \(arg[1]) г.")
                }
                .onDelete(perform: removeRows)
            }
        }
        
        .navigationTitle("Приемы пищи")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    for i in foodItems {
                        let arg = "\(i)".components(separatedBy: "//")
                        SaveToDB(FoodName: arg[0], gram: arg[1], selectedDate: date, selectedType: previewIndex.rawValue)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Сохранить")
                }
            })
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
        }
        .ignoresSafeArea(.keyboard)
    }
    func removeRows(at offsets: IndexSet){
        foodItems.remove(atOffsets: offsets)
    }
    init() {
        UIScrollView.appearance().keyboardDismissMode = .onDrag
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
}
