//
//  addCustomMeal.swift
//  dia
//
//  Created by Артём Исаков on 12.09.2022.
//

import SwiftUI

struct recipeInteractionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var collection: foodCollections
    @State var viewStatement: interactorStatement
    @State var preinitialized: Bool
    @State var details: recipeDetails?
    @State var idToDelete: Int?
    @State var foodNotation: String
    @State var selectedCat: foodCategories
    @State var imageURL: String
    @State private var permission: Bool = false
    @State private var errorMessage: String = "Заполните поля в соотвествии с требованиями"
    @State private var showEditView: Bool = false
    @State private var isUnsavedChanges: Bool = false
    var body: some View {
        if #available(iOS 16, *) {
            List {
                if viewStatement == .add || viewStatement == .edit {
                    Section(header: Text("Общая информация").font(.caption)){
                        TextField("Название блюда", text: $foodNotation)
                            .autocorrectionDisabled()
                        NavigationLink(destination: categoryPicker(selectedCat: $selectedCat)) {
                            Text(selectedCat.rawValue)
                        }
                    }
                    Section(header: Text("Изображение").font(.caption)) {
                        TextField("Вставьте ссылку (URL)", text: $imageURL)
                            .autocorrectionDisabled()
                    }
                }
                Section {
                    ForEach($collection.recipeFoodItems, id: \.id){ $i in
                        VStack(alignment: .leading) {
                            indicatorGroup(gi: $i.gi, carbo: $i.weightedСarbo, gl: $i.gl)
                            Text("\(i.name) (\(i.gram!, specifier: "%.1f") г.)")
                        }
                        .padding(.vertical, 7)
                        .swipeActions {
                            Button(action: {removeRows(i: collection.recipeFoodItems.firstIndex(where: {$0.id == i.id})!)}, label: {
                                Image(systemName: "trash.fill")
                            })
                            .tint(Color.red)
                        }
                        .swipeActions {
                            Button(action: {
                                collection.selectedItem = i
                                withAnimation(.default){
                                    showEditView = true
                                }
                            }, label: {
                                Image(systemName: "pencil")
                            })
                            .tint(Color.orange)
                        }
                    }
                } header: {
                    if !collection.recipeFoodItems.isEmpty {
                        Text("Составляющие рецепта").font(.caption)
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationBarBackButtonHidden()
            .navigationTitle(getTitle())
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button {
                        if (viewStatement == .view) || (collection.whereToSave == .recipeFoodItems && collection.recipeFoodItems.isEmpty) {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                                collection.recipeFoodItems = []
                            })
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            isUnsavedChanges = true
                        }
                    } label: {
                        HStack {
                            Text(Image(systemName: "chevron.left")).font(.body).fontWeight(.semibold)
                            Text("Назад").font(.body)
                        }
                    }
                })
                ToolbarItem(placement: .navigationBarTrailing) {
                    switch viewStatement {
                    case .view:
                        Button {
                            withAnimation {
                                viewStatement = .edit
                            }
                        } label: {
                            HStack {
                                Text("Изменить")
                                Image(systemName: "pencil")
                            }
                        }
                    case .edit:
                        Button {
                            do {
                                diaryManager.provider.addNewFood(items: try checkIsEmpty(items: collection.recipeFoodItems), newReceitName: try patientManager.provider.checkName(txt: foodNotation), category: selectedCat.rawValue, isEditing: true, idToDelete: idToDelete, imageURL: imageURL)
                                collection.recipeFoodItems = []
                                presentationMode.wrappedValue.dismiss()
                            }
                            catch {
                                permission = true
                            }
                        } label: {
                            Text("Сохранить")
                        }
                    case .add:
                        Button {
                            do {
                                diaryManager.provider.addNewFood(items: try checkIsEmpty(items: collection.recipeFoodItems), newReceitName: try patientManager.provider.checkName(txt: foodNotation), category: selectedCat.rawValue, isEditing: false, idToDelete: idToDelete, imageURL: imageURL)
                                collection.recipeFoodItems = []
                                presentationMode.wrappedValue.dismiss()
                            }
                            catch {
                                permission = true
                            }
                        } label: {
                            Text("Внести")
                        }
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        UIApplication.shared.dismissedKeyboard()
                    } label: {
                        Text("Готово")
                    }
                }
                if viewStatement != .view {
                    ToolbarItemGroup(placement: .bottomBar, content: {
                        Spacer()
                        NavigationLink(destination: { enterPoint() }, label: {
                            Image(systemName: "square.and.pencil")
                        }).foregroundColor(Color("AccentColor"))
                    })
                }
            }
            .sheet(isPresented: $showEditView, content: { addGramButton(gram: String(collection.selectedItem!.gram!).split(separator: ".").joined(separator: ","), editing: true, isShowingSheet: $showEditView, showSuccesNotify: .constant(false)).dynamicTypeSize(.xLarge)})
            .alert(isPresented: $permission) {
                Alert(title: Text("Статус операции"), message: Text(errorMessage), dismissButton: .default(Text("ОК")))
            }
            .alert("Несохраненные изменения", isPresented: $isUnsavedChanges, actions: {
                Button(role: .destructive, action: {
                    if collection.whereToSave == .recipeFoodItems {
                        collection.recipeFoodItems = []
                    }
                    presentationMode.wrappedValue.dismiss()
                }, label: {Text("Покинуть")})
            }, message: {Text("Вы внесли изменения, но не сохранили их. Если вы покините страницу - временные данные будут удалены.")})
            .task {
                collection.whereToSave = .recipeFoodItems
                if preinitialized {
                    var temp = [foodItem]()
                    for j in 0..<details!.item_id.count {
                        temp.append(foodItem(table_id: details!.item_id[j], name: details!.item_name[j], prot: details!.prot[j], fat: details!.fat[j], carbo: details!.carbo[j], kkal: details!.kkal[j], gi: details!.gi[j], gram: details!.gram[j]))
                    }
                    collection.recipeFoodItems = temp
                    preinitialized = false
                }
            }
        } else {
            List {
                if viewStatement == .add || viewStatement == .edit {
                    Section(header: Text("Общая информация").font(.caption)){
                        TextField("Название блюда", text: $foodNotation)
                            .autocorrectionDisabled()
                        NavigationLink(destination: categoryPicker(selectedCat: $selectedCat)) {
                            Text(selectedCat.rawValue)
                        }
                    }
                    Section(header: Text("Изображение").font(.caption)) {
                        TextField("Вставьте ссылку (URL)", text: $imageURL)
                            .autocorrectionDisabled()
                    }
                }
                if viewStatement != .view {
                    Section {
                        NavigationLink(destination: { enterPoint() }, label: {
                            HStack {
                                Text("Добавить")
                                Image(systemName: "folder.badge.plus")
                            }
                        }).foregroundColor(Color("AccentColor"))
                    }
                }
                Section {
                    ForEach($collection.recipeFoodItems, id: \.id){ $i in
                        VStack(alignment: .leading) {
                            indicatorGroup(gi: $i.gi, carbo: $i.weightedСarbo, gl: $i.gl)
                            Text("\(i.name) (\(i.gram!, specifier: "%.1f") г.)")
                        }
                        .padding(.vertical, 7)
                        .swipeActions {
                            Button(action: {removeRows(i: collection.recipeFoodItems.firstIndex(where: {$0.id == i.id})!)}, label: {
                                Image(systemName: "trash.fill")
                            })
                            .tint(Color.red)
                        }
                        .swipeActions {
                            Button(action: {
                                collection.selectedItem = i
                                withAnimation(.default){
                                    showEditView = true
                                }
                            }, label: {
                                Image(systemName: "pencil")
                            })
                            .tint(Color.orange)
                        }
                    }
                } header: {
                    if !collection.recipeFoodItems.isEmpty {
                        Text("Составляющие рецепта").font(.caption)
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationBarBackButtonHidden()
            .navigationTitle(getTitle())
            .hiddenTabBar()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button {
                        if (viewStatement == .view) || (collection.whereToSave == .recipeFoodItems && collection.recipeFoodItems.isEmpty) {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                                collection.recipeFoodItems = []
                            })
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            isUnsavedChanges = true
                        }
                    } label: {
                        HStack {
                            Text(Image(systemName: "chevron.left")).font(.body).fontWeight(.semibold)
                            Text("Назад").font(.body)
                        }
                    }
                })
                ToolbarItem(placement: .navigationBarTrailing) {
                    switch viewStatement {
                    case .view:
                        Button {
                            withAnimation {
                                viewStatement = .edit
                            }
                        } label: {
                            HStack {
                                Text("Изменить")
                                Image(systemName: "pencil")
                            }
                        }
                    case .edit:
                        Button {
                            do {
                                diaryManager.provider.addNewFood(items: try checkIsEmpty(items: collection.recipeFoodItems), newReceitName: try patientManager.provider.checkName(txt: foodNotation), category: selectedCat.rawValue, isEditing: true, idToDelete: idToDelete, imageURL: imageURL)
                                collection.recipeFoodItems = []
                                presentationMode.wrappedValue.dismiss()
                            }
                            catch {
                                permission = true
                            }
                        } label: {
                            Text("Сохранить")
                        }
                    case .add:
                        Button {
                            do {
                                diaryManager.provider.addNewFood(items: try checkIsEmpty(items: collection.recipeFoodItems), newReceitName: try patientManager.provider.checkName(txt: foodNotation), category: selectedCat.rawValue, isEditing: false, idToDelete: idToDelete, imageURL: imageURL)
                                collection.recipeFoodItems = []
                                presentationMode.wrappedValue.dismiss()
                            }
                            catch {
                                permission = true
                            }
                        } label: {
                            Text("Внести")
                        }
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        UIApplication.shared.dismissedKeyboard()
                    } label: {
                        Text("Готово")
                    }
                }
            }
            .sheet(isPresented: $showEditView, content: { addGramButton(gram: String(collection.selectedItem!.gram!).split(separator: ".").joined(separator: ","), editing: true, isShowingSheet: $showEditView, showSuccesNotify: .constant(false)).dynamicTypeSize(.xLarge)})
            .alert(isPresented: $permission) {
                Alert(title: Text("Статус операции"), message: Text(errorMessage), dismissButton: .default(Text("ОК")))
            }
            .alert("Несохраненные изменения", isPresented: $isUnsavedChanges, actions: {
                Button(role: .destructive, action: {
                    if collection.whereToSave == .recipeFoodItems {
                        collection.recipeFoodItems = []
                    }
                    presentationMode.wrappedValue.dismiss()
                }, label: {Text("Покинуть")})
            }, message: {Text("Вы внесли изменения, но не сохранили их. Если вы покините страницу - временные данные будут удалены.")})
            .task {
                collection.whereToSave = .recipeFoodItems
                if preinitialized {
                    var temp = [foodItem]()
                    for j in 0..<details!.item_id.count {
                        temp.append(foodItem(table_id: details!.item_id[j], name: details!.item_name[j], prot: details!.prot[j], fat: details!.fat[j], carbo: details!.carbo[j], kkal: details!.kkal[j], gi: details!.gi[j], gram: details!.gram[j]))
                    }
                    collection.recipeFoodItems = temp
                    preinitialized = false
                }
            }
        }
    }
    func removeRows(i: Int){
        collection.recipeFoodItems.remove(at: i)
    }
    func checkIsEmpty(items: [foodItem]) throws -> [foodItem] {
        guard !items.isEmpty else {
            throw inputErorrs.EmptyError
        }
        return items
    }
    func getTitle() -> String {
        switch viewStatement {
            case .view:
                return "\(foodNotation)"
            case .edit:
                return "Изменить рецепт"
            case .add:
                return "Создать рецепт"
            }
    }
}

struct categoryPicker : View {
    @Binding var selectedCat: foodCategories
    var body: some View {
        List {
            Picker(selection: $selectedCat, label: Text("Категория продукта").font(.caption)){
                ForEach(foodCategories.allCases){ obj in
                    Text(obj.rawValue)
                }
            }.pickerStyle(.inline)
        }
    }
}
