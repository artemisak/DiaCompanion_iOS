//
//  recipeAsyncList.swift
//  dia
//
//  Created by Артём Исаков on 23.02.2023.
//

import SwiftUI

enum interactorStatement {
    case view, edit, add
}

struct recipeAsyncList: View {
    @EnvironmentObject var collection: foodCollections
    @StateObject var allRecipes = recipeModel()
    let columns = [GridItem(.flexible(), spacing: 0, alignment: .top), GridItem(.flexible(), spacing: 0, alignment: .top)]
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    Section {
                        ForEach(allRecipes.recipes, id: \.id){i in
                            NavigationLink {
                                recipeInteractionView(viewStatement: .view, preinitialized: true, details: i, idToDelete: i.table_id, foodNotation: i.name, selectedCat: .alcohol, imageURL: i.url)
                            } label: {
                                recipeCard(imageURL: URL(string: i.url), title: i.name)
                            }
                        }
                    }.padding(.top, 35)
                }
            }
            .background {
                if allRecipes.recipes.isEmpty {
                    VStack {
                        Spacer()
                        HStack{
                            Text("Добавьте рецепт")
                            Image(systemName: "plus.app")
                        }.foregroundColor(.gray)
                        Spacer()
                    }.ignoresSafeArea()
                }
            }
            .task {
                allRecipes.fillRecipes()
            }
        }
        .navigationTitle("Рецепты")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: {
                    recipeInteractionView(viewStatement: .add, preinitialized: false, details: nil, foodNotation: "", selectedCat: .alcohol, imageURL: "")
                }, label: {
                    HStack{
                        Text("Добавить")
                        Image(systemName: "plus")
                    }
                })
            }
        }
    }
    func retriveRecipe(row: recipeDetails) -> [recipe] {
        var temp: [recipe] = []
        for i in 0..<row.item_id.count {
            temp.append(recipe(item: row.item_name[i], table_id: row.item_id[i], gram: row.gram[i]))
        }
        return temp
    }
}

struct recipeAsyncList_Previews: PreviewProvider {
    static var previews: some View {
        recipeAsyncList()
            .environmentObject(foodCollections())
    }
}
