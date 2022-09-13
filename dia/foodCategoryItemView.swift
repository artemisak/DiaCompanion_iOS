//
//  foodCategoryItemView.swift
//  dia
//
//  Created by Артём Исаков on 05.09.2022.
//

import SwiftUI

struct foodCategoryItemView: View {
    @State var selectedFoodCategoryItem : String = ""
    @State var successedSave: Bool = false
    @State var addScreen: Bool = false
    @State var gram: String = ""
    @State var selectedFoodTemp: String = ""
    @State var selectedFoodTempRating: Int = 0
    @State var category: String
    @Binding var foodItems: [foodToSave]
    @Binding var txtTheme: DynamicTypeSize
    @EnvironmentObject var items: Food
    var body: some View {
        ZStack {
            VStack(spacing: .zero) {
                VStack(spacing: .zero) {
                    Divider()
                    HStack{
                        TextField(text: $selectedFoodCategoryItem, label: {Text("Поиск по слову").dynamicTypeSize(txtTheme)}).disableAutocorrection(true)
                        Image(systemName: "xmark").foregroundColor(Color(red: 87/255, green: 165/255, blue: 248/255))
                            .onTapGesture {
                                selectedFoodCategoryItem = ""
                            }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12.5)
                    Divider()
                }
                ScrollView {
                    VStack(spacing: .zero) {
                        ForEach(items.FoodObj.filter{$0.name.contains(selectedFoodCategoryItem) || selectedFoodCategoryItem.isEmpty}.sorted(by: {$0.rating > $1.rating}), id: \.id){dish in
                            VStack(spacing: .zero) {
                                foodButton(dish: dish, selectedFoodTemp: $selectedFoodTemp, addScreen: $addScreen, successedSave: $successedSave)
                                    .contextMenu {
                                        Button(action: {
                                            items.handleRatingChange(i: items.FoodObj.firstIndex(where: {$0.id == dish.id})!)
                                            changeRating(_name: dish.name, _rating: dish.rating)
                                            items.CatID = UUID()
                                        }, label: {
                                            HStack {
                                                Text(dish.rating == 0 ? "Добавить в избранное" : "Удалить из избранного").font(.system(size: 18.5))
                                                Image(systemName: dish.rating == 0 ? "star" : "star.fill")
                                            }
                                        })
                                    }
                                Divider()
                            }
                        }
                    }
                }
                .id(items.CatID)
                .ignoresSafeArea(.keyboard)
            }
            if addScreen {
                addSreenView(addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodTemp, foodItems: $foodItems, successedSave: $successedSave)
            }
            if successedSave {
                savedNotice()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(category)
        .toolbar {
            ToolbarItem(placement: .keyboard, content: {
                HStack{
                    Spacer()
                    Button(action: {
                        UIApplication.shared.dismissedKeyboard()
                    }, label: {
                        Text("Готово").dynamicTypeSize(txtTheme)
                    })
                }
            })
        }
        .task {
            items.GetFoodCategoryItems(_category: category)
        }
        .onChange(of: successedSave, perform: {save in
            if save {
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                    successedSave = false
                })
            }
        })
    }
}
