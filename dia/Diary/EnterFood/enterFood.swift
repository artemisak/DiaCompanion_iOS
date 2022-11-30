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
    @State private var showEditView: Bool = false
    @State private var id0: Int = 0
    @State var enabled : Bool
    @State var sugar: String
    @State private var isEditing: Bool = false
    @State private var sugarlvl: String = "УСК не определен"
    @State private var isHidden: Bool = true
    @State var date: Date
    @State private var foodn: String = ""
    @State private var i: Int = 0
    @State private var isSheetShown: Bool = false
    @State var foodItems: [foodToSave] = []
    @State var ftpreviewIndex: ftype
    @State private var lvlColor: Color?
    @State private var scolor: Color?
    @State private var recColor = Color.gray.opacity(0.3)
    @State private var fontColor = Color.black
    @State private var alertMessage: Bool = false
    @State var idForDelete: [Int]
    @State private var permission: Bool = false
    @State private var correctness: Bool = false
    @State private var res: Double = 0.0
    @State private var errorMessage: String = ""
    @State private var recommendMessage: String = ""
    @State private var isVisible: Bool = false
    @Binding var txtTheme: DynamicTypeSize
    @Binding var hasChanged: Bool
    @EnvironmentObject var islogin: Router
    var body: some View {
        ZStack {
            List {
                Section(header: Text("Общая информация").font(.system(size: 15.5))){
                    NavigationLink(destination: ftPicker(ftpreviewIndex: $ftpreviewIndex).navigationBarTitleDisplayMode(.inline), label: {
                        HStack{
                            Text("Прием пищи")
                            Spacer()
                            Text("\(ftpreviewIndex.rawValue)")
                        }
                    }).onChange(of: ftpreviewIndex, perform: { _ in
                        do {
                            if (foodItems.count != 0 && sugar != "" && islogin.version != 2) {
                                var food: [String] = []
                                var gram: [Double] = []
                                try foodItems.forEach {
                                    food.append($0.name.components(separatedBy: "////")[0])
                                    gram.append( try convert(txt: $0.name.components(separatedBy: "////")[1]))
                                }
                                let foodNutrients = getData(BG0: try convert(txt: sugar), foodtype: ftpreviewIndex, foodN: food, gram: gram, picker_date: date)
                                res = try getPredict(BG0: foodNutrients.BG0, gl: foodNutrients.gl, carbo: foodNutrients.carbo, prot: foodNutrients.protb6h, t1: foodNutrients.food_type1, t2: foodNutrients.food_type2, t3: foodNutrients.food_type3, t4: foodNutrients.food_type4, kr: foodNutrients.kr, BMI: foodNutrients.BMI)
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
                                recColor = Color.gray.opacity(0.3)
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
                    VStack {
                        DatePicker(
                            "Дата",
                            selection: $date,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                    .onChange(of: date, perform: { _ in
                        do {
                            if (foodItems.count != 0 && sugar != "" && islogin.version != 2) {
                                var food: [String] = []
                                var gram: [Double] = []
                                try foodItems.forEach {
                                    food.append($0.name.components(separatedBy: "////")[0])
                                    gram.append( try convert(txt: $0.name.components(separatedBy: "////")[1]))
                                }
                                let foodNutrients = getData(BG0: try convert(txt: sugar), foodtype: ftpreviewIndex, foodN: food, gram: gram, picker_date: date)
                                res = try getPredict(BG0: foodNutrients.BG0, gl: foodNutrients.gl, carbo: foodNutrients.carbo, prot: foodNutrients.protb6h, t1: foodNutrients.food_type1, t2: foodNutrients.food_type2, t3: foodNutrients.food_type3, t4: foodNutrients.food_type4, kr: foodNutrients.kr, BMI: foodNutrients.BMI)
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
                                recColor = Color.gray.opacity(0.3)
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
                }
                if islogin.version != 2 {
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
                            .frame(maxWidth: .infinity)
                            .foregroundColor(lvlColor)
                            .listRowBackground(recColor)
                        TextField("5,0 ммоль/л", text: $sugar)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .keyboardType(.decimalPad)
                            .disabled(enabled == false)
                            .foregroundColor(scolor)
                            .onChange(of: sugar){_ in
                                do {
                                    if (foodItems.count != 0 && sugar != "" && islogin.version != 2) {
                                        var food: [String] = []
                                        var gram: [Double] = []
                                        try foodItems.forEach {
                                            food.append($0.name.components(separatedBy: "////")[0])
                                            gram.append( try convert(txt: $0.name.components(separatedBy: "////")[1]))
                                        }
                                        let foodNutrients = getData(BG0: try convert(txt: sugar), foodtype: ftpreviewIndex, foodN: food, gram: gram, picker_date: date)
                                        res = try getPredict(BG0: foodNutrients.BG0, gl: foodNutrients.gl, carbo: foodNutrients.carbo, prot: foodNutrients.protb6h, t1: foodNutrients.food_type1, t2: foodNutrients.food_type2, t3: foodNutrients.food_type3, t4: foodNutrients.food_type4, kr: foodNutrients.kr, BMI: foodNutrients.BMI)
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
                                        recColor = Color.gray.opacity(0.3)
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
                    ForEach(foodItems, id: \.id) {i in
                        let arg = "\(i.name)".components(separatedBy: "////")
                        Text("\(arg[0]), \(arg[1]) г.")
                            .swipeActions {
                                Button(action: {removeRows(i: foodItems.firstIndex(where: {$0.id == i.id})!)}, label: {
                                    Image(systemName: "trash.fill")
                                })
                                .tint(Color.red)
                            }
                            .swipeActions {
                                Button(action: {
                                    id0 = foodItems.firstIndex(where: {$0.id == i.id})!
                                    withAnimation(.default){
                                        showEditView = true
                                    }
                                }, label: {
                                    Image(systemName: "pencil")
                                })
                                .tint(Color.orange)
                            }
                    }
                }
            }
            .onChange(of: foodItems, perform: { _ in
                do {
                    if (foodItems.count != 0 && sugar != "" && islogin.version != 2) {
                        var food: [String] = []
                        var gram: [Double] = []
                        try foodItems.forEach {
                            food.append($0.name.components(separatedBy: "////")[0])
                            gram.append( try convert(txt: $0.name.components(separatedBy: "////")[1]))
                        }
                        let foodNutrients = getData(BG0: try convert(txt: sugar), foodtype: ftpreviewIndex, foodN: food, gram: gram, picker_date: date)
                        res = try getPredict(BG0: foodNutrients.BG0, gl: foodNutrients.gl, carbo: foodNutrients.carbo, prot: foodNutrients.protb6h, t1: foodNutrients.food_type1, t2: foodNutrients.food_type2, t3: foodNutrients.food_type3, t4: foodNutrients.food_type4, kr: foodNutrients.kr, BMI: foodNutrients.BMI)
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
                        recColor = Color.gray.opacity(0.3)
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
                        permission = checkIfAlreadyEx(selectedDate: date, idForDelete: idForDelete)
                        if permission {
                            errorMessage = "Удалите или отредактиируйте уже существующий прием пищи"
                        }
                        if enabled && !permission {
                            do {
                                let _BG0 = try convert(txt: sugar)
                                if !idForDelete.isEmpty {
                                    deleteFromBD(idToDelete: idForDelete, table: 0)
                                    hasChanged = true
                                }
                                for i in foodItems {
                                    let arg = "\(i.name)".components(separatedBy: "////")
                                    SaveToDB(FoodName: arg[0], gram: arg[1], table_id: arg[2], selectedDate: date, selectedType: ftpreviewIndex.rawValue)
                                }
                                addPredictedRecord(selectedDate: date, selectedType: ftpreviewIndex.rawValue, BG0: _BG0, BG1: res)
                                recommendMessage = getMessage(highGI: checkGI(listOfFood: foodItems), manyCarbo: checkCarbo(foodType: ftpreviewIndex.rawValue, listOfFood: foodItems), highBGBefore: checkBGBefore(BG0: _BG0), lowPV: checkPV(listOfFood: foodItems, date: date), bg_pred: res, isTrue: &isVisible)
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            catch {
                                print(error)
                                permission = true
                                errorMessage = "Заполните поля в соотвествии с требованиями"
                            }
                        }
                        else if !enabled && !permission {
                            if !idForDelete.isEmpty {
                                deleteFromBD(idToDelete: idForDelete, table: 0)
                                hasChanged = true
                            }
                            for i in foodItems {
                                let arg = "\(i.name)".components(separatedBy: "////")
                                SaveToDB(FoodName: arg[0], gram: arg[1], table_id: arg[2], selectedDate: date, selectedType: ftpreviewIndex.rawValue)
                            }
                            addPredictedRecord(selectedDate: date, selectedType: ftpreviewIndex.rawValue, BG0: 0.0, BG1: 0.0)
                            recommendMessage = getMessage(highGI: checkGI(listOfFood: foodItems), manyCarbo: checkCarbo(foodType: ftpreviewIndex.rawValue, listOfFood: foodItems), highBGBefore: checkBGBefore(BG0: 5.0), lowPV: checkPV(listOfFood: foodItems, date: date), bg_pred: res, isTrue: &isVisible)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Сохранить").dynamicTypeSize(txtTheme)
                    }
                    .alert(isPresented: $permission) {
                        Alert(title: Text("Статус операции"), message: Text(errorMessage), dismissButton: .default(Text("ОК")))
                    }
                })
                ToolbarItemGroup(placement: .keyboard, content: {
                    Spacer()
                    Button(action: {
                        UIApplication.shared.dismissedKeyboard()
                    }, label: {
                        Text("Готово").dynamicTypeSize(txtTheme).foregroundColor(Color(red: 0/255, green: 150/255, blue: 255/255))
                    })
                })
            }
            .alert(isPresented: $isVisible) {
                Alert(title: Text("Рекомендации"), message: Text(recommendMessage), dismissButton: .default(Text("ОК")))
            }
            .ignoresSafeArea(.keyboard)
            .onAppear {
                UIScrollView.appearance().keyboardDismissMode = .onDrag
                UITableView.appearance().showsVerticalScrollIndicator = false
            }
            .task {
                do {
                    if (foodItems.count != 0 && sugar != "" && islogin.version != 2) {
                        var food: [String] = []
                        var gram: [Double] = []
                        try foodItems.forEach {
                            food.append($0.name.components(separatedBy: "////")[0])
                            gram.append( try convert(txt: $0.name.components(separatedBy: "////")[1]))
                        }
                        let foodNutrients = getData(BG0: try convert(txt: sugar), foodtype: ftpreviewIndex, foodN: food, gram: gram, picker_date: date)
                        res = try getPredict(BG0: foodNutrients.BG0, gl: foodNutrients.gl, carbo: foodNutrients.carbo, prot: foodNutrients.protb6h, t1: foodNutrients.food_type1, t2: foodNutrients.food_type2, t3: foodNutrients.food_type3, t4: foodNutrients.food_type4, kr: foodNutrients.kr, BMI: foodNutrients.BMI)
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
                        recColor = Color.gray.opacity(0.3)
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
            if showEditView {
                editScreenView(id: $id0, foodItems: $foodItems, showEditView: $showEditView)
            }
        }
    }
    func removeRows(i: Int){
        foodItems.remove(at: i)
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

struct foodToSave: Identifiable, Hashable {
    var id = UUID()
    var name: String
}
