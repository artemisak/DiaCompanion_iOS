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
    @State private var isEditing: Bool = false
    @State private var sugarlvl: String = "УСК не определен"
    @State private var isHidden: Bool = true
    @State private var date = Date()
    @State private var foodn: String = ""
    @State private var i: Int = 0
    @State private var isSheetShown: Bool = false
    @State private var foodItems: [String] = []
    @State private var ftpreviewIndex = ftype.zavtrak
    @State private var lvlColor: Color?
    @State private var scolor: Color?
    @State private var recColor = Color.white
    @State private var fontColor = Color.black
    @State private var alertMessage: Bool = false
    @FocusState private var focuseField: Bool
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
                }).onChange(of: ftpreviewIndex, perform: { _ in
                    do {
                        if (foodItems.count != 0 && sugar != "") {
                            var food: [String] = []
                            var gram: [Double] = []
                            try foodItems.forEach {
                                food.append($0.components(separatedBy: "////")[0])
                                gram.append( try convert(txt: $0.components(separatedBy: "////")[1]))
                            }
                            let foodNutrients = getData(BG0: try convert(txt: sugar), foodtype: ftpreviewIndex, foodN: food, gram: gram, picker_date: date)
                            let res = try getPredict(BG0: foodNutrients.BG0, gl: foodNutrients.gl, carbo: foodNutrients.carbo, prot: foodNutrients.protb6h, t1: foodNutrients.food_type1, t2: foodNutrients.food_type2, t3: foodNutrients.food_type3, t4: foodNutrients.food_type4, kr: foodNutrients.kr, BMI: foodNutrients.BMI)
                            if res < 6.8 {
                                sugarlvl = "УСК не превысит норму"
                                recColor = Color.green.opacity(0.7)
                                fontColor = Color.white
                            } else {
                                sugarlvl = "УСК превысит норму"
                                recColor = Color(red: 255/255, green: 91/255, blue: 36/255)
                                fontColor = Color.white
                            }
                            scolor = .black
                        } else {
                            sugarlvl = "УСК не определен"
                            recColor = Color.white
                            fontColor = Color.black
                        }
                    }
                    catch inputErorrs.decimalError {
                        scolor = .red
                    }
                    catch modelErorrs.generalError {
                        scolor = .red
                    }
                    catch {
                        scolor = .red
                    }
                })
                DatePicker(
                    "Дата",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .environment(\.locale, .init(identifier: "ru"))
                .onChange(of: date, perform: { _ in
                    do {
                        if (foodItems.count != 0 && sugar != "") {
                            var food: [String] = []
                            var gram: [Double] = []
                            try foodItems.forEach {
                                food.append($0.components(separatedBy: "////")[0])
                                gram.append( try convert(txt: $0.components(separatedBy: "////")[1]))
                            }
                            let foodNutrients = getData(BG0: try convert(txt: sugar), foodtype: ftpreviewIndex, foodN: food, gram: gram, picker_date: date)
                            let res = try getPredict(BG0: foodNutrients.BG0, gl: foodNutrients.gl, carbo: foodNutrients.carbo, prot: foodNutrients.protb6h, t1: foodNutrients.food_type1, t2: foodNutrients.food_type2, t3: foodNutrients.food_type3, t4: foodNutrients.food_type4, kr: foodNutrients.kr, BMI: foodNutrients.BMI)
                            if res < 6.8 {
                                sugarlvl = "УСК не превысит норму"
                                recColor = Color.green.opacity(0.7)
                                fontColor = Color.white
                            } else {
                                sugarlvl = "УСК превысит норму"
                                recColor = Color(red: 255/255, green: 91/255, blue: 36/255)
                                fontColor = Color.white
                            }
                            scolor = .black
                        } else {
                            sugarlvl = "УСК не определен"
                            recColor = Color.white
                            fontColor = Color.black
                        }
                    }
                    catch inputErorrs.decimalError {
                        scolor = .red
                    }
                    catch modelErorrs.generalError {
                        scolor = .red
                    }
                    catch {
                        scolor = .red
                    }
                })
                .environment(\.locale, Locale.init(identifier: "ru")).frame(height: 42.7)
            }
            Section(header: Text("Уровень сахара в крови").font(.system(size: 15.5))) {
                Toggle(isOn: $enabled) {Text("Записать текущий УСК")}
                    .onChange(of: enabled){ _ in
                        if (!checkBMI() && enabled) {
                            alertMessage = true
                            enabled = false
                        }
                        sugar = ""
                        sugarlvl = "УСК не определен"
                    }
                    .alert(isPresented: $alertMessage) {
                        Alert(title: Text("Статус операции"), message: Text("Необходимо указать рост и вес \nдо беременности в карте пациента"), dismissButton: .default(Text("ОК")))
                    }
            }
            Section {
                Text("\(sugarlvl)")
                    .foregroundColor(fontColor)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(lvlColor)
                    .listRowBackground(recColor)
                TextField("5,0 ммоль/л", text: $sugar)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .focused($focuseField)
                    .keyboardType(.decimalPad)
                    .disabled(enabled == false)
                    .foregroundColor(scolor)
                    .onChange(of: sugar){_ in
                        do {
                            if (foodItems.count != 0 && sugar != "") {
                                var food: [String] = []
                                var gram: [Double] = []
                                try foodItems.forEach {
                                    food.append($0.components(separatedBy: "////")[0])
                                    gram.append( try convert(txt: $0.components(separatedBy: "////")[1]))
                                }
                                let foodNutrients = getData(BG0: try convert(txt: sugar), foodtype: ftpreviewIndex, foodN: food, gram: gram, picker_date: date)
                                let res = try getPredict(BG0: foodNutrients.BG0, gl: foodNutrients.gl, carbo: foodNutrients.carbo, prot: foodNutrients.protb6h, t1: foodNutrients.food_type1, t2: foodNutrients.food_type2, t3: foodNutrients.food_type3, t4: foodNutrients.food_type4, kr: foodNutrients.kr, BMI: foodNutrients.BMI)
                                if res < 6.8 {
                                    sugarlvl = "УСК не превысит норму"
                                    recColor = Color.green.opacity(0.7)
                                    fontColor = Color.white
                                } else {
                                    sugarlvl = "УСК превысит норму"
                                    recColor = Color(red: 255/255, green: 91/255, blue: 36/255)
                                    fontColor = Color.white
                                }
                                scolor = .black
                            } else {
                                sugarlvl = "УСК не определен"
                                recColor = Color.white
                                fontColor = Color.black
                            }
                        }
                        catch inputErorrs.decimalError {
                            scolor = .red
                        }
                        catch modelErorrs.generalError {
                            scolor = .red
                        }
                        catch {
                            scolor = .red
                        }
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
                    addFoodButton(foodItems: $foodItems, txtTheme: $txtTheme).dynamicTypeSize(txtTheme)
                }
            }
            Section {
                ForEach(foodItems, id: \.self) {i in
                    let arg = "\(i)".components(separatedBy: "////")
                    Text("\(arg[0]), \(arg[1]) г.")
                }
                .onDelete(perform: removeRows)
            }
        }
        .onChange(of: foodItems, perform: { _ in
            do {
                if (foodItems.count != 0 && sugar != "") {
                    var food: [String] = []
                    var gram: [Double] = []
                    try foodItems.forEach {
                        food.append($0.components(separatedBy: "////")[0])
                        gram.append( try convert(txt: $0.components(separatedBy: "////")[1]))
                    }
                    let foodNutrients = getData(BG0: try convert(txt: sugar), foodtype: ftpreviewIndex, foodN: food, gram: gram, picker_date: date)
                    let res = try getPredict(BG0: foodNutrients.BG0, gl: foodNutrients.gl, carbo: foodNutrients.carbo, prot: foodNutrients.protb6h, t1: foodNutrients.food_type1, t2: foodNutrients.food_type2, t3: foodNutrients.food_type3, t4: foodNutrients.food_type4, kr: foodNutrients.kr, BMI: foodNutrients.BMI)
                    if res < 6.8 {
                        sugarlvl = "УСК не превысит норму"
                        recColor = Color.green.opacity(0.7)
                        fontColor = Color.white
                    } else {
                        sugarlvl = "УСК превысит норму"
                        recColor = Color(red: 255/255, green: 91/255, blue: 36/255)
                        fontColor = Color.white
                    }
                    scolor = .black
                } else {
                    sugarlvl = "УСК не определен"
                    recColor = Color.white
                    fontColor = Color.black
                }
            }
            catch inputErorrs.decimalError {
                scolor = .red
            }
            catch modelErorrs.generalError {
                scolor = .red
            }
            catch {
                scolor = .red
            }
        })
        .navigationTitle("Приемы пищи")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    for i in foodItems {
                        let arg = "\(i)".components(separatedBy: "////")
                        SaveToDB(FoodName: arg[0], gram: arg[1], selectedDate: date, selectedType: ftpreviewIndex.rawValue)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Сохранить").dynamicTypeSize(txtTheme)
                }
            })
            ToolbarItem(placement: .keyboard, content: {
                HStack{
                    Spacer()
                    Button(action: {
                        focuseField = false
                    }, label: {
                        Text("Готово")
                            .dynamicTypeSize(txtTheme)
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
            Picker(selection: $ftpreviewIndex, label: Text("Прием пищи").font(.system(size: 15.5))) {
                Text("Завтрак").tag(ftype.zavtrak)
                Text("Обед").tag(ftype.obed)
                Text("Ужин").tag(ftype.uzin)
                Text("Перекусы").tag(ftype.perekus)
            }.pickerStyle(.inline)
        }
    }
}
