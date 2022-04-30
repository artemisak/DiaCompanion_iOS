//
//  page3.swift
//  dia
//
//  Created by Артем  on 22.08.2021.
//

import SwiftUI

enum ftype: String, CaseIterable, Identifiable {
    case zavtrak = "Завтрак"
    case obed = "Обед"
    case uzin = "Ужин"
    case perekus = "Перекусы"
    var id: String { self.rawValue }
}

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
    @State private var foodItems: [String] = []
    @State private var ftpreviewIndex = ftype.zavtrak
    @State private var lvlColor: Color?
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        List {
            Section(header: Text("Общая информация").font(.system(size: 15.5))){
                NavigationLink(destination: ftPicker(ftpreviewIndex: $ftpreviewIndex), label: {
                    HStack{
                        Text("Прием пищи")
                        Spacer()
                        Text("\(ftpreviewIndex.rawValue)")
                    }
                })
                DatePicker(
                    "Дата",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .environment(\.locale, Locale.init(identifier: "ru"))
            }
            Section(header: Text("Уровень сахара в крови").font(.system(size: 15.5))) {
                Toggle(isOn: $enabled) {Text("Записать текущий УСК")}
                    .onChange(of: enabled){_ in
                        sugar = ""
                        sugarlvl = "УСК не определен"
                    }
            }
            Section {
                Text("\(sugarlvl)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(lvlColor)
                TextField("5,0 ммоль/л", text: $sugar)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .keyboardType(.decimalPad)
                    .disabled(enabled == false)
                    .onChange(of: sugar){s in
                        sugarlvl = getPredict(sugar: s).0
                        lvlColor = getPredict(sugar: s).1
                    }
            }
            Section(header: Text("Потребленные продукты").font(.system(size: 15.5))){
                Button(action:{
                    isSheetShown.toggle()
                }, label:{
                    HStack{
                        Text("Добавить")
                        Image(systemName: "folder.badge.plus")
                    }
                })
                .sheet(isPresented: $isSheetShown) {
                    addFoodButton(foodItems: $foodItems).dynamicTypeSize(txtTheme)
                }
            }
            Section {
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
                        SaveToDB(FoodName: arg[0], gram: arg[1], selectedDate: date, selectedType: ftpreviewIndex.rawValue)
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
                            .foregroundColor(Color(red: 0, green: 0.590, blue: 1))
                    })
                }
            })
        }
        .ignoresSafeArea(.keyboard)
        .onAppear(perform: {
            UIScrollView.appearance().keyboardDismissMode = .onDrag
            UITableView.appearance().showsVerticalScrollIndicator = false
        })
    }
    func removeRows(at offsets: IndexSet){
        foodItems.remove(atOffsets: offsets)
    }
}

struct ftPicker: View {
    @Binding var ftpreviewIndex: ftype
    var body: some View {
        Form {
            Picker(selection: $ftpreviewIndex, label: Text("Прием пищи")) {
                Text("Завтрак").tag(ftype.zavtrak)
                Text("Обед").tag(ftype.obed)
                Text("Ужин").tag(ftype.uzin)
                Text("Перекусы").tag(ftype.perekus)
            }.pickerStyle(.inline)
        }
    }
}
