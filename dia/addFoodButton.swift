//
//  addFoodButton.swift
//  dia
//
//  Created by Артем  on 05.11.2021.
//

import SwiftUI

struct addFoodButton: View {
    @Binding var foodItems: [String]
    @State public var addScreen: Bool = true
    @State public var selectedFoodTemp: String = ""
    @State public var selectedFoodCategoryTemp: String = ""
    @State public var gram: String = ""
    @State private var selectedFood: String = ""
    @State private var selectedFoodCategoryItem: String = ""
    @State private var searchByWordView: Bool = true
    @State private var searchByWordCategoryView: Bool = true
    @State private var FoodList: [FoodList] = []
    @State private var FoodList2: [FoodList] = []
    var body: some View {
        ZStack {
            List {
                Section {
                    ForEach(FoodList){dish in
                        if !searchByWordView {
                            DoButton(dish: dish)
                        } else {
                            DoLink(dish: dish)
                        }
                    }
                }
            }
            .onAppear(perform: {
                FoodList = FillFoodCategoryList()
                
            })
            .listStyle(.plain)
            if !addScreen {
                addSreenView(addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodTemp, foodItems: $foodItems)
            }
        }
        .navigationTitle("Добавить блюдо")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: $selectedFood,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt:  "Поиск по слову"
        )
        .onChange(of: selectedFood, perform: {selectedFood in
            if !selectedFood.isEmpty {
                FoodList = GetFoodItemsByName(_name: selectedFood)
                searchByWordView = false
            } else {
                FoodList = FillFoodCategoryList()
                searchByWordView = true
            }
        })
    }
    
    func DoButton(dish: FoodList) -> some View {
        Button(action: {
            selectedFoodCategoryTemp = dish.name
            addScreen.toggle()
        }){Text("\(dish.name)")}
    }
    
    func DoLink(dish: FoodList) -> some View {
        NavigationLink(destination: GetFoodCategoryItemsView(category: "\(dish.name)")) {
            Text("\(dish.name)")
        }.foregroundColor(.black)
    }
    
    func GetFoodCategoryItemsView(category: String) -> some View {
        ZStack {
            List {
                Section {
                    ForEach(FoodList2){dish in
                        DoButton(dish: dish)
                    }
                }
            }
            if !addScreen {
                addSreenView(addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodCategoryTemp, foodItems: $foodItems)
            }
        }
        .onAppear(perform:{
            FoodList2 = GetFoodCategoryItems(_category: category)
        })
        .searchable(
            text: $selectedFoodCategoryItem,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Поиск по слову"
        )
        .onChange(of: selectedFoodCategoryItem, perform: {i in
            if !i.isEmpty{
                FoodList2 = GetFoodCategoryItems(_category: category).filter{$0.name.contains(selectedFoodCategoryItem)}
            } else {
                FoodList2 = GetFoodCategoryItems(_category: category)
            }
        })
        .listStyle(.plain)
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct addFoodButton_Previews: PreviewProvider {
    static var previews: some View {
        addFoodButton(foodItems: .constant([]))
    }
}

