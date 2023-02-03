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

struct ftPicker: View {
    @Binding var ftpreviewIndex: ftype
    var body: some View {
        List {
            Picker(selection: $ftpreviewIndex, label: Text("Прием пищи").font(.caption)) {
                Text("Завтрак").tag(ftype.zavtrak)
                Text("Обед").tag(ftype.obed)
                Text("Ужин").tag(ftype.uzin)
                Text("Перекусы").tag(ftype.perekus)
            }.pickerStyle(.inline)
        }
    }
}

struct enterFood: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var routeManager: Router
    @EnvironmentObject var collection: foodCollections
    @State var enabled : Bool
    @State var sugar: String
    @State var date: Date
    @State var ftpreviewIndex: ftype
    @State var idForDelete: [Int]
    @State private var multiSelection = Set<UUID>()
    @State private var showEditView: Bool = false
    @State private var id0: Int = 0
    @State private var isEditing: Bool = false
    @State private var sugarlvl: String = "УСК не определен"
    @State private var isHidden: Bool = true
    @State private var isSheetShown: Bool = false
    @State private var scolor = Color.black
    @State private var recColor = Color.gray.opacity(0.2)
    @State private var fontColor = Color.black
    @State private var alertMessage: Bool = false
    @State private var permission: Bool = false
    @State private var correctness: Bool = false
    @State private var res: Double = 0.0
    @State private var errorMessage: String = ""
    @State private var recommendMessage: String = ""
    @State private var isVisible: Bool = false
    @State private var isUnsavedChanges: Bool = false
    @Binding var hasChanged: Bool
    var body: some View {
        List {
            Section(header: Text("Общая информация").font(.caption)){
                NavigationLink(destination: ftPicker(ftpreviewIndex: $ftpreviewIndex), label: {
                    HStack {
                        Text("Прием пищи")
                        Spacer()
                        Text("\(ftpreviewIndex.rawValue)")
                    }
                })
                VStack {
                    DatePicker(
                        "Дата",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            }
            if routeManager.version == 1 {
                Section(header: Text("Уровень сахара в крови").font(.caption)) {
                    Toggle(isOn: $enabled) {Text("Записать текущий УСК")}
                        .onChange(of: enabled){ _ in
                            if (!pacientManager.provider.checkBMI() && enabled) {
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
                        .bold()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(fontColor)
                        .listRowBackground(recColor)
                    if isVisible {
                        Text(recommendMessage)
                    }
                    TextField("5,0 ммоль/л", text: $sugar)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .keyboardType(.decimalPad)
                        .disabled(enabled == false)
                        .foregroundColor(scolor)
                }.listRowSeparator(.hidden)
            }
            Section(header: Text("Потребленные продукты").font(.caption)){
                NavigationLink(destination: { enterPoint() }, label: {
                    HStack {
                        Text("Добавить")
                        Image(systemName: "folder.badge.plus")
                    }
                }).foregroundColor(Color("AccentColor"))
            }
            Section {
                ForEach(collection.whereToSave == .addedFoodItems ? collection.addedFoodItems : collection.editedFoodItems, id: \.id) {i in
                    Label {
                        Text("\(i.name) (\(i.gram!, specifier: "%.1f") г.)")
                    } icon: {
                        giIndicator(gi: i.gi, gl: i.gl)
                    }
                    .labelStyle(centerLabel())
                    .swipeActions {
                        Button(action: {
                            if collection.whereToSave == .addedFoodItems {
                                removeRows(i: collection.addedFoodItems.firstIndex(where: {$0.id == i.id})!)
                            } else {
                                removeRows(i: collection.editedFoodItems.firstIndex(where: {$0.id == i.id})!)
                            }
                        }, label: {
                            Image(systemName: "trash.fill")
                        })
                        .tint(Color.red)
                    }
                    .swipeActions {
                        Button(action: {
                            if collection.whereToSave == .addedFoodItems {
                                id0 = collection.addedFoodItems.firstIndex(where: {$0.id == i.id})!
                                collection.selectedItem = i
                                withAnimation(.default){
                                    showEditView = true
                                }
                            } else {
                                id0 = collection.editedFoodItems.firstIndex(where: {$0.id == i.id})!
                                collection.selectedItem = i
                                withAnimation(.default){
                                    showEditView = true
                                }
                            }
                        }, label: {
                            Image(systemName: "pencil")
                        })
                        .tint(Color.orange)
                    }
                }
            } header: {
                if (!collection.addedFoodItems.isEmpty && collection.whereToSave == .addedFoodItems) || (!collection.editedFoodItems.isEmpty && collection.whereToSave == .editingFoodItems) {
                    Text("ГИ / ГН / Наименование, г.").frame(minWidth: 0, maxWidth: .infinity).font(.body)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Приемы пищи")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    if collection.whereToSave == .addedFoodItems {
                        saveInDB(workList: collection.addedFoodItems)
                        collection.addedFoodItems = []
                    } else {
                        saveInDB(workList: collection.editedFoodItems)
                        collection.editedFoodItems = []
                    }
                }) {
                    Text("Сохранить")
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
                    Text("Готово").foregroundColor(Color(red: 0/255, green: 150/255, blue: 255/255))
                })
            })
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button {
                    switch collection.whereToSave {
                    case .addedFoodItems:
                        if collection.addedFoodItems.isEmpty {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            isUnsavedChanges = true
                        }
                    case .editingFoodItems:
                        if collection.editedFoodItems.isEmpty {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            isUnsavedChanges = true
                        }
                    default:
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    HStack {
                        Text(Image(systemName: "chevron.left")).font(.body).fontWeight(.semibold)
                        Text("Назад").font(.body)
                    }
                }
            })
        }
        .sheet(isPresented: $showEditView, content: { addGramButton(gram: String(collection.selectedItem!.gram!).split(separator: ".").joined(separator: ","), editing: true, isShowingSheet: $showEditView, showSuccesNotify: .constant(false))})
        .alert("Несохраненные изменения", isPresented: $isUnsavedChanges, actions: {
            Button(role: .destructive, action: {
                switch collection.whereToSave {
                case .addedFoodItems:
                    collection.addedFoodItems = []
                case .editingFoodItems:
                    collection.editedFoodItems = []
                default:
                    break
                }
                presentationMode.wrappedValue.dismiss()
            }, label: {Text("Покинуть")})
        }, message: {Text("Вы внесли изменения, но не сохранили их. Если вы покините страницу - временные данные будут удалены.")})
        .onAppear {
            if idForDelete.isEmpty {
                collection.whereToSave = .addedFoodItems
            } else {
                collection.whereToSave = .editingFoodItems
            }
            if collection.whereToSave == .addedFoodItems {
                date = Date()
                updatePrediction(workList: collection.addedFoodItems)
            } else {
                updatePrediction(workList: collection.editedFoodItems)
            }
        }
        .onReceive(collection.$addedFoodItems, perform: { _ in
            updatePrediction(workList: collection.addedFoodItems)
        })
        .onReceive(collection.$editedFoodItems, perform: { _ in
            updatePrediction(workList: collection.editedFoodItems)
        })
        .onChange(of: sugar){ _ in
            if collection.whereToSave == .addedFoodItems {
                updatePrediction(workList: collection.addedFoodItems)
            } else {
                updatePrediction(workList: collection.editedFoodItems)
            }
        }
        .onChange(of: ftpreviewIndex, perform: { _ in
            if collection.whereToSave == .addedFoodItems {
                updatePrediction(workList: collection.addedFoodItems)
            } else {
                updatePrediction(workList: collection.editedFoodItems)
            }
        })
        .onChange(of: date, perform: { _ in
            if collection.whereToSave == .addedFoodItems {
                updatePrediction(workList: collection.addedFoodItems)
            } else {
                updatePrediction(workList: collection.editedFoodItems)
            }
        })
    }
    func removeRows(i: Int){
        if collection.whereToSave == .addedFoodItems {
            collection.addedFoodItems.remove(at: i)
        } else {
            collection.editedFoodItems.remove(at: i)
        }
    }
    func updatePrediction(workList: [foodItem]){
        do {
            if (workList.count != 0 && sugar != "" && routeManager.version != 2) {
                var food: [String] = []
                var gram: [Double] = []
                workList.forEach {
                    food.append($0.name)
                    gram.append($0.gram!)
                }
                let foodNutrients = getData(BG0: try convert(txt: sugar), foodtype: ftpreviewIndex, foodN: food, gram: gram, picker_date: date)
                res = try getPredict(BG0: foodNutrients.BG0, gl: foodNutrients.gl, carbo: foodNutrients.carbo, prot: foodNutrients.protb6h, t1: foodNutrients.food_type1, t2: foodNutrients.food_type2, t3: foodNutrients.food_type3, t4: foodNutrients.food_type4, kr: foodNutrients.kr, BMI: foodNutrients.BMI)
                recommendMessage = getMessage(highBGPredict: checkBGPredicted(BG1: res), highBGBefore: checkBGBefore(BG0: try convert(txt: sugar)), manyCarbo: checkCarbo(foodType: ftpreviewIndex.rawValue, listOfFood: workList), unequalGLDistribution: checkUnequalGlDistribution(listOfFood: workList), highGI: checkGI(listOfFood: workList))
                if res < 6.8 {
                    sugarlvl = "УСК не превысит норму"
                    recColor = Color.green.opacity(0.7)
                    fontColor = Color.white
                    isVisible = false
                } else {
                    sugarlvl = "УСК превысит норму"
                    recColor = Color(red: 255/255, green: 91/255, blue: 36/255)
                    fontColor = Color.white
                    isVisible = true
                }
                scolor = .black
            } else {
                sugarlvl = "УСК не определен"
                recColor = Color("BG_Undefined")
                fontColor = Color("BG_Font_Undefined")
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
    func saveInDB(workList: [foodItem]){
        permission = diaryManager.provider.checkIfAlreadyEx(selectedDate: date, idForDelete: idForDelete)
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
                for i in workList {
                    diaryManager.provider.SaveToDB(FoodName: i.name, gram: "\(i.gram!)", table_id: "\(i.table_id)", selectedDate: date, selectedType: ftpreviewIndex.rawValue)
                }
                diaryManager.provider.addPredictedRecord(selectedDate: date, selectedType: ftpreviewIndex.rawValue, BG0: _BG0, BG1: res)
                collection.selectedItem = nil
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
            for i in workList {
                diaryManager.provider.SaveToDB(FoodName: i.name, gram: "\(i.gram!)", table_id: "\(i.table_id)", selectedDate: date, selectedType: ftpreviewIndex.rawValue)
            }
            diaryManager.provider.addPredictedRecord(selectedDate: date, selectedType: ftpreviewIndex.rawValue, BG0: 0.0, BG1: 0.0)
            collection.selectedItem = nil
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}


