//
//  addFoodButton.swift
//  dia
//
//  Created by Артем  on 05.11.2021.
//

import SwiftUI

struct addFoodButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State public var addScreen: Bool = true
    @State private var searchByWordView: Bool = true
    @State private var searchByWordCategoryView: Bool = true
    @State public var gram: String = ""
    @State private var selectedFood: String = ""
    @State private var selectedFoodCategoryItem: String = ""
    @State private var selectedFoodTemp: String = ""
    @State private var selectedFoodCategoryTemp: String = ""
    @State private var FoodCList: [FoodCategory] = FillFoodCategoryList()
    @State private var FoodList: [FoodItemByName] = []
    @Binding var foodItems: [String]
    @MainActor
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    if !searchByWordView {
                        Section {
                            ForEach(FoodList){i in
                                Button(action: {
                                    selectedFoodTemp = i.name
                                    addScreen.toggle()
                                }){Text("\(i.name)")}.foregroundColor(.black)
                            }
                        }
                    } else {
                        Section {
                            ForEach(FoodCList){i in
                                NavigationLink(destination: GetFoodCategoryItemsView(category: "\(i.name)")) {
                                    Text("\(i.name)")
                                }.foregroundColor(.black)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                if !addScreen {
                    addSreenView(addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodTemp, foodItems: $foodItems)
                }
            }
            .navigationTitle("Add the dish")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                }
            }
            .interactiveDismissDisabled()
        }
        .searchable(
            text: $selectedFood,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt:  "Search by word"
        )
        .onChange(of: selectedFood, perform: {i in
            Task {
                if i.isEmpty {
                    searchByWordView = true
                } else {
                    FoodList = await GetFoodItemsByName(_name: selectedFood)
                    searchByWordView = false
                }
            }
        })
    }
    
    func GetFoodCategoryItemsView(category: String) -> some View {
        ZStack {
            List {
                Section {
                    ForEach(searchByWordCategoryView ? GetFoodCategoryItems(_category: category):GetFoodCategoryItems(_category: category).filter{$0.name.contains(selectedFoodCategoryItem)}){i in
                        Button(action: {
                            selectedFoodCategoryTemp = i.name
                            addScreen.toggle()
                        }){Text("\(i.name)")}
                    }
                }
            }
            if !addScreen {
                addSreenView(addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodCategoryTemp, foodItems: $foodItems)
            }
        }
        .searchable(
            text: $selectedFoodCategoryItem,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search by word"
        )
        .onChange(of: selectedFoodCategoryItem, perform: {i in
            searchByWordCategoryView = i.isEmpty ? true : false
        })
        .listStyle(.plain)
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled()
    }
}

struct addFoodButton_Previews: PreviewProvider {
    static var previews: some View {
        addFoodButton(foodItems: .constant([]))
    }
}

