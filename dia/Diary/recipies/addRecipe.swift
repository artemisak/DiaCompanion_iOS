//
//  addCustomMeal.swift
//  dia
//
//  Created by Артём Исаков on 12.09.2022.
//

import SwiftUI

struct addRecipe: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var collection: foodCollections
    @State var editExistRow: Bool
    @State var idToDelete: Int?
    @State var foodNotation: String
    @State var selectedCat: foodCategories
    @State private var permission: Bool = false
    @State private var errorMessage: String = "Заполните поля в соотвествии с требованиями"
    @State private var showEditView: Bool = false
    @State private var isUnsavedChanges: Bool = false
    @FocusState private var focus: Bool
    var body: some View {
        List {
            Section(header: Text("Общая информация").font(.caption)){
                TextField("Название блюда", text: $foodNotation)
                    .focused($focus)
                    .autocorrectionDisabled()
                NavigationLink(destination: categoryPicker(selectedCat: $selectedCat)) {
                    Text(selectedCat.rawValue)
                }
            }
            Section(header: Text("Составляющие рецепта").font(.caption)){
                NavigationLink(destination: enterPoint(), label: {
                    HStack{
                        Text("Добавить ингредиент")
                        Image(systemName: "folder.badge.plus")
                    }
                }).foregroundColor(Color("AccentColor"))
            }
            Section {
                ForEach($collection.recipeFoodItems, id: \.id){ $i in
                    VStack(alignment: .leading) {
                        giIndicator(gi: $i.gi, carbo: $i.carbo, gl: $i.gl)
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
                if (!collection.recipeFoodItems.isEmpty && collection.whereToSave == .recipeFoodItems) {
                    Text("ГИ / ГН / Угл. / Продукт, г.").frame(minWidth: 0, maxWidth: .infinity).font(.body)
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarBackButtonHidden()
        .navigationTitle(editExistRow ? "Изменить рецепт" : "Создать рецепт")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button {
                    if collection.whereToSave == .recipeFoodItems && collection.recipeFoodItems.isEmpty {
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
                Button {
                    do {
                        diaryManager.provider.addNewFood(items: try checkIsEmpty(items: collection.recipeFoodItems), newReceitName: try pacientManager.provider.checkName(txt: foodNotation), category: selectedCat.rawValue, isEditing: editExistRow, idToDelete: idToDelete)
                        collection.recipeFoodItems = []
                        presentationMode.wrappedValue.dismiss()
                    }
                    catch {
                        permission = true
                    }
                } label: {
                    Text("Сохранить")
                }
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button {
                    focus = false
                } label: {
                    Text("Готово")
                }
            }
        }
        .sheet(isPresented: $showEditView, content: { addGramButton(gram: String(collection.selectedItem!.gram!).split(separator: ".").joined(separator: ","), editing: true, isShowingSheet: $showEditView, showSuccesNotify: .constant(false))})
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
