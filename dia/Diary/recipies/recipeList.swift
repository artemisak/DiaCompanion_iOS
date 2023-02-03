//
//  recipeList.swift
//  dia
//
//  Created by Артём Исаков on 20.01.2023.
//

import SwiftUI

struct recipeList: View {
    @EnvironmentObject var collection: foodCollections
    @StateObject var allRecipes = recipeModel()
    @State private var food: [foodItem] = []
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            VStack {
                if !allRecipes.recipes.isEmpty {
                    List {
                        ForEach(allRecipes.recipes, id: \.id){i in
                            NavigationLink {
                                recipeRow(name: i.name, table_id: i.table_id, item: retriveRecipe(row: i))
                            } label: {
                                Text(i.name)
                            }
                            .swipeActions {
                                Button {
                                    removeRow(at: IndexSet(integer: allRecipes.recipes.firstIndex(of: i)!))
                                } label: {
                                    Image(systemName: "trash.fill")
                                }
                                .tint(.red)
                            }
                            .swipeActions {
                                NavigationLink(destination: {
                                    addRecipe(editExistRow: true, idToDelete: i.table_id, foodNotation: i.name, selectedCat: .alcohol)
                                        .task {
                                            collection.whereToSave = .recipeFoodItems
                                            var temp = [foodItem]()
                                            for j in 0..<i.item_id.count {
                                                temp.append(foodItem(table_id: i.item_id[j], name: i.item_name[j], prot: i.prot[j], fat: i.fat[j], carbo: i.carbo[j], kkal: i.kkal[j], gi: i.gi[j], gram: i.gram[j]))
                                            }
                                            collection.recipeFoodItems = temp
                                        }
                                }) {
                                    Image(systemName: "pencil")
                                }
                                .tint(.orange)
                            }
                        }
                    }
                } else {
                    HStack{
                        Text("Добавьте рецепт")
                        Image(systemName: "plus.app")
                    }.foregroundColor(.gray)
                }
            }
        }
        .task {
            allRecipes.fillRecipes()
        }
        .navigationTitle("Рецепты")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: {
                    if #available(iOS 16, *){
                        addRecipe(editExistRow: false, foodNotation: "", selectedCat: .alcohol)
                            .task {
                                collection.whereToSave = .recipeFoodItems
                            }
                            .toolbar(.hidden, for: .tabBar)
                    } else {
                        addRecipe(editExistRow: false, foodNotation: "", selectedCat: .alcohol)
                            .task {
                                collection.whereToSave = .recipeFoodItems
                            }
                            .hiddenTabBar()
                    }
                }, label: {
                    HStack{
                        Text("Добавить")
                        Image(systemName: "plus")
                    }
                })
            }
        }
    }
    func removeRow(at offsets: IndexSet){
        offsets.sorted(by: > ).forEach {i in
            allRecipes.deleteRecipe(item: allRecipes.recipes[i])
        }
        allRecipes.recipes.remove(atOffsets: offsets)
    }
    func retriveRecipe(row: recipeDetails) -> [recipe] {
        var temp: [recipe] = []
        for i in 0..<row.item_id.count {
            temp.append(recipe(item: row.item_name[i], table_id: row.item_id[i], gram: row.gram[i]))
        }
        return temp
    }
}

struct recipeList_Previews: PreviewProvider {
    static var previews: some View {
        recipeList()
    }
}
