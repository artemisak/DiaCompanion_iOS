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
            Picker(selection: $ftpreviewIndex, label: Text("Прием пищи").font(.body)) {
                Text(LocalizedStringKey("Завтрак")).tag(ftype.zavtrak)
                Text(LocalizedStringKey("Обед")).tag(ftype.obed)
                Text(LocalizedStringKey("Ужин")).tag(ftype.uzin)
                Text(LocalizedStringKey("Перекусы")).tag(ftype.perekus)
            }.pickerStyle(.inline)
        }
    }
}

struct enterFood: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var routeManager: Router
    @EnvironmentObject var collection: foodCollections
    @State var sugar: String
    @State var date: Date
    @State var ftpreviewIndex: ftype
    @State var dateForDelete: Date?
    @State var idForDelete: [Int]
    @State private var multiSelection = Set<UUID>()
    @State private var showEditView: Bool = false
    @State private var id0: Int = 0
    @State private var isEditing: Bool = false
    @State private var sugarlvl: LocalizedStringKey = ""
    @State private var isHidden: Bool = true
    @State private var isSheetShown: Bool = false
    @State private var scolor = Color("listButtonColor")
    @State private var recColor = Color.gray.opacity(0.2)
    @State private var fontColor = Color.black
    @State private var alertMessage: Bool = false
    @State private var denied: Bool = false
    @State private var correctness: Bool = false
    @State private var res: Double = 0.0
    @State private var errorMessage: String = ""
    @State private var isVisible: Bool = false
    @State private var isUnsavedChanges: Bool = false
    @State private var recCardID = UUID()
    @State private var recomendationCards = [recomendation]()
    @State private var showDetails: Bool = false
    @Binding var hasChanged: Bool
    var body: some View {
        List {
            Section(header: Text("Общая информация").font(.body)){
                generalFoodInfo(previewIndex: $ftpreviewIndex, date: $date)
            }
            if routeManager.version == 1 {
                Section {
                    sugarInput(sugar: $sugar).foregroundColor(scolor)
                } header: {
                    if isVisible {
                        sugarMessage(message: $sugarlvl, msgColor: $recColor, recomendations: $recomendationCards).onTapGesture {
                            if !recomendationCards.isEmpty {
                                showDetails.toggle()
                            }
                        }
                    } else {
                        Text("Уровень глюкозы в крови").font(.body)
                    }
                } footer: {
                    if isVisible {
                        Text("Введенный УГК до приема пищи").frame(minWidth: .zero, maxWidth: .infinity).multilineTextAlignment(.center).font(.caption)
                    } else {
                        Text("Введите значение для получения диетических рекомендаций").frame(minWidth: .zero, maxWidth: .infinity).multilineTextAlignment(.center).font(.caption)
                    }
                }
            }
            if collection.showFoodCollections {
                Section {
                    foodList(showEditView: $showEditView, id0: $id0)
                } header: {
                    Text("Список продуктов").font(.body)
                } footer: {
                    Text("Смахните влево, чтобы удалить или отредактировать").font(.caption).frame(minWidth: 0, maxWidth: .infinity).multilineTextAlignment(.center)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Приемы пищи")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    do {
                        let BG0 = try convert(txt: sugar)
                        denied = diaryManager.provider.checkIfAlreadyEx(selectedDate: date, idForDelete: idForDelete)
                        if denied {
                            errorMessage = "Удалите или отредактируйте уже существующий прием пищи"
                        } else {
                            if collection.whereToSave == .addedFoodItems {
                                if collection.addedFoodItems.isEmpty {
                                    denied = true
                                    errorMessage = "Введите состав приема пищи"
                                } else {
                                    saveInDB(workList: collection.addedFoodItems, bg: BG0)
                                    collection.addedFoodItems = []
                                }
                            } else {
                                if collection.editedFoodItems.isEmpty {
                                    denied = true
                                    errorMessage = "Введите состав приема пищи"
                                } else {
                                    saveInDB(workList: collection.editedFoodItems, bg: BG0)
                                    collection.editedFoodItems = []
                                }
                            }
                        }
                    } catch inputErorrs.EmptyError {
                        denied = diaryManager.provider.checkIfAlreadyEx(selectedDate: date, idForDelete: idForDelete)
                        if denied {
                            errorMessage = "Удалите или отредактируйте уже существующий прием пищи"
                        } else {
                            if collection.whereToSave == .addedFoodItems {
                                if collection.addedFoodItems.isEmpty {
                                    denied = true
                                    errorMessage = "Введите состав приема пищи"
                                } else {
                                    saveInDB(workList: collection.addedFoodItems, bg: 0.0)
                                    collection.addedFoodItems = []
                                }
                            } else {
                                if collection.editedFoodItems.isEmpty {
                                    denied = true
                                    errorMessage = "Введите состав приема пищи"
                                } else {
                                    saveInDB(workList: collection.editedFoodItems, bg: 0.0)
                                    collection.editedFoodItems = []
                                }
                            }
                        }
                    } catch {
                        denied = true
                        errorMessage = "Заполните поля в соотвествии с требованиями"
                    }
                }) {
                    Text("Сохранить")
                }
                .alert(isPresented: $denied) {
                    Alert(title: Text("Статус операции"), message: Text(LocalizedStringKey(errorMessage)), dismissButton: .default(Text("ОК")))
                }
            })
            ToolbarItemGroup(placement: .bottomBar, content: {
                Spacer()
                NavigationLink(destination: { enterPoint() }, label: {
                    Image(systemName: "square.and.pencil")
                }).foregroundColor(Color("AccentColor"))
            })
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button {
                    switch collection.whereToSave {
                    case .addedFoodItems:
                        if collection.addedFoodItems.isEmpty && sugar.isEmpty {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            isUnsavedChanges = true
                        }
                    case .editingFoodItems:
                        if collection.editedFoodItems.isEmpty && sugar.isEmpty {
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
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button(action: {
                    UIApplication.shared.dismissedKeyboard()
                }, label: {
                    Text("Готово").foregroundColor(Color(red: 0/255, green: 150/255, blue: 255/255))
                })
            })
        }
        .sheet(isPresented: $showEditView, content: { addGramButton(gram: String(collection.selectedItem!.gram!).split(separator: ".").joined(separator: ","), editing: true, isShowingSheet: $showEditView, showSuccesNotify: .constant(false)).dynamicTypeSize(.medium)})
        .sheet(isPresented: $showDetails, content: {
            recomendationView(recomendations: $recomendationCards).dynamicTypeSize(.medium)
        })
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
                updatePrediction(workList: collection.addedFoodItems)
            } else {
                updatePrediction(workList: collection.editedFoodItems)
            }
        }
        .onChange(of: collection.addedFoodItems, perform: { _ in
            updatePrediction(workList: collection.addedFoodItems)
        })
        .onChange(of: collection.editedFoodItems, perform: { _ in
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
                let model_input = predictManager.provider.getData(BG0: try convert(txt: sugar), foodtype: ftpreviewIndex, foodN: food, gram: gram, picker_date: date)
                res = try predictManager.provider.getPredict(meal_type_n: model_input.meal_type_n, gi: model_input.gi, gl: model_input.gl, carbo: model_input.carbo, carbo_b6h: model_input.carbo_b6h, prot_b6h: model_input.prot_b6h, fat_b6h: model_input.fat_b6h, BG: model_input.BG, BMI: model_input.BMI, HbA1C_V1: model_input.HbA1C_V1, TG_V1: model_input.TG_V1, Hol_V1: model_input.Hol_V1, fasting_glu: model_input.fasting_glu, pregnancy_week: model_input.pregnancy_week)
                let checkCarbo = checkCarbo(foodType: ftpreviewIndex.rawValue, listOfFood: workList, date: date)
                let msg = getMessage(BGPredicted: res, BGBefore: try convert(txt: sugar), moderateAmountOfCarbo: checkCarbo.0, tooManyCarbo: checkCarbo.1, twiceAsMach: checkCarbo.2, unequalGLDistribution: checkUnequalGlDistribution(listOfFood: workList), highGI: checkGI(listOfFood: workList))
                recomendationCards = msg.0
                res = msg.2
                recCardID = recomendationCards.isEmpty ? UUID() : recomendationCards[0].id
                if msg.1 == "превысит" {
                    withAnimation(.none) {
                        isVisible = true
                        recColor = Color.red
                        sugarlvl = LocalizedStringKey(msg.1)
                    }
                } else if msg.1 == "не превысит" {
                    withAnimation(.none) {
                        isVisible = true
                        sugarlvl = LocalizedStringKey(msg.1)
                        recColor = Color.green
                    }
                }
            } else {
                withAnimation(.none) {
                    isVisible = false
                }
            }
            scolor = Color("listButtonColor")
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
    func saveInDB(workList: [foodItem], bg: Double){
        if bg != 0.0 {
            if !idForDelete.isEmpty && dateForDelete != nil {
                deleteFromBD(idToDelete: idForDelete, table: 0)
                deleteCorespondingRecords(date: dateForDelete!)
                hasChanged = true
            }
            for i in workList {
                diaryManager.provider.SaveToDB(FoodName: i.name, gram: "\(i.gram!)", table_id: "\(i.table_id)", selectedDate: date, selectedType: ftpreviewIndex.rawValue)
            }
            diaryManager.provider.addPredictedRecord(selectedDate: date, selectedType: ftpreviewIndex.rawValue, BG0: bg, BG1: res)
            collection.selectedItem = nil
            self.presentationMode.wrappedValue.dismiss()
        } else {
            if !idForDelete.isEmpty && dateForDelete != nil {
                deleteFromBD(idToDelete: idForDelete, table: 0)
                deleteCorespondingRecords(date: dateForDelete!)
                hasChanged = true
            }
            for i in workList {
                diaryManager.provider.SaveToDB(FoodName: i.name, gram: "\(i.gram!)", table_id: "\(i.table_id)", selectedDate: date, selectedType: ftpreviewIndex.rawValue)
            }
            collection.selectedItem = nil
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
