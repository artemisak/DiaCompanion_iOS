import SwiftUI

struct addFoodButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var foodItems: [foodToSave]
    @State public var addScreen: Bool = false
    @State public var selectedFoodTemp: String = ""
    @State public var selectedFoodTempRating: Int = 0
    @State public var selectedFoodCategoryTemp: String = ""
    @State public var gram: String = ""
    @State private var selectedFood: String = ""
    @State private var selectedFoodCategoryItem: String = ""
    @State private var searchByWordView: Bool = true
    @State private var searchByWordCategoryView: Bool = true
    @State public var successedSave: Bool = false
    @StateObject private var items = Food()
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack(spacing: .zero) {
                    VStack(spacing: .zero) {
                        Divider()
                        HStack {
                            TextField(text: $selectedFood, prompt: Text("Поиск по слову"), label: {EmptyView()}).disableAutocorrection(true)
                            Image(systemName: "xmark").foregroundColor(Color(red: 87/255, green: 165/255, blue: 248/255))
                                .onTapGesture {
                                    selectedFood = ""
                                }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12.5)
                        Divider()
                    }
                    if searchByWordView {
                        ScrollView {
                            VStack(spacing: .zero) {
                                ForEach(items.CatObj, id: \.id){dish in
                                    VStack(spacing: .zero) {
                                        DoLink(dish: dish)
                                        Divider()
                                    }
                                }
                            }
                        }
                        .ignoresSafeArea(.keyboard)
                    } else {
                        ScrollView {
                            VStack(spacing: .zero) {
                                ForEach(items.FoodObj.sorted(by: {$0.rating > $1.rating}), id: \.id) {dish in
                                    VStack(spacing: .zero) {
                                        DoButton(dish: dish)
                                            .contextMenu {
                                                Button(action: {
                                                    if items.FoodObj[items.FoodObj.firstIndex(where: {$0.name == dish.name})!].rating == 0 {
                                                        items.FoodObj[items.FoodObj.firstIndex(where: {$0.name == dish.name})!].rating = 1
                                                    } else {
                                                        items.FoodObj[items.FoodObj.firstIndex(where: {$0.name == dish.name})!].rating = 0
                                                    }
                                                    changeRating(_name: dish.name, _rating: dish.rating)
                                                }, label: {
                                                    HStack {
                                                        Text(dish.rating == 0 ? "Добавить в избранное" : "Удалить из избранного")
                                                        Image(systemName: dish.rating == 0 ? "star" : "star.fill")
                                                    }
                                                })
                                            }
                                        Divider()
                                    }
                                }
                            }
                        }
                        .id(UUID())
                        .ignoresSafeArea(.keyboard)
                    }
                }
                if addScreen {
                    addSreenView(addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodTemp, foodItems: $foodItems, successedSave: $successedSave)
                }
                if successedSave {
                    savedNotice()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Добавить блюдо")
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Закрыть").dynamicTypeSize(txtTheme)
                    }
                })
                ToolbarItem(placement: .keyboard, content: {
                    HStack {
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
                items.FillFoodCategoryList()
            }
            .onChange(of: selectedFood, perform: {selectedFood in
                if !selectedFood.isEmpty {
                    searchByWordView = false
                    items.GetFoodItemsByName(_name: selectedFood)
                } else {
                    searchByWordView = true
                    items.FillFoodCategoryList()
                }
            })
            .onChange(of: successedSave, perform: {save in
                if save {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.75, execute: {
                        withAnimation(.spring()){
                            successedSave = false
                        }
                    })
                }
            })
            .onAppear(perform: {
                successedSave = false
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    func GetFoodCategoryItemsView(category: String) -> some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: .zero) {
                VStack(spacing: .zero) {
                    Divider()
                    HStack{
                        TextField(text: $selectedFoodCategoryItem, prompt: Text("Поиск по слову"), label: {EmptyView()}).disableAutocorrection(true)
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
                                DoButton(dish: dish)
                                    .contextMenu {
                                        Button(action: {
                                            if items.FoodObj[items.FoodObj.firstIndex(where: {$0.name == dish.name})!].rating == 0 {
                                                items.FoodObj[items.FoodObj.firstIndex(where: {$0.name == dish.name})!].rating = 1
                                            } else {
                                                items.FoodObj[items.FoodObj.firstIndex(where: {$0.name == dish.name})!].rating = 0
                                            }
                                            changeRating(_name: dish.name, _rating: dish.rating)
                                        }, label: {
                                            HStack {
                                                Text(dish.rating == 0 ? "Добавить в избранное" : "Удалить из избранного")
                                                Image(systemName: dish.rating == 0 ? "star" : "star.fill")
                                            }
                                        })
                                    }
                                Divider()
                            }
                        }
                    }
                }
                .id(UUID())
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
                DispatchQueue.main.asyncAfter(deadline: .now()+1.75, execute: {
                    withAnimation(.spring()){
                        successedSave = false
                    }
                })
            }
        })
    }
    
    @ViewBuilder
    func DoButton(dish: FoodList) -> some View {
        Button(action: {
            selectedFoodTemp = dish.name
            selectedFoodTempRating = dish.rating
            addScreen = true
        }){
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Text("Б")
                            .foregroundColor(Color.gray)
                        Text("\(dish.prot)").foregroundColor(.orange)
                    }.font(.system(size: 18.5))
                    VStack {
                        Text("Ж")
                            .foregroundColor(Color.gray)
                        Text("\(dish.fat)").foregroundColor(.green)
                    }.font(.system(size: 18.5))
                    VStack {
                        Text("У")
                            .foregroundColor(Color.gray)
                        Text("\(dish.carbo)").foregroundColor(.blue)
                    }.font(.system(size: 18.5))
                    VStack {
                        Text("ГИ")
                            .foregroundColor(Color.gray)
                        Text("\(dish.gi)").foregroundColor(.red)
                    }.font(.system(size: 18.5))
                }
                Text("\(dish.name)").frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).font(.system(size: 20)).multilineTextAlignment(.leading).foregroundColor(.black)
            }
            .padding(.horizontal)
            .padding(.vertical, 12.5)
            .background(dish.rating == 0 ? nil : Color.green.opacity(0.3))
        }
    }
    
    @ViewBuilder
    func DoLink(dish: CategoryList) -> some View {
        NavigationLink(destination: GetFoodCategoryItemsView(category: "\(dish.name)")) {
            Text("\(dish.name)").frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).font(.system(size: 20)).multilineTextAlignment(.leading).foregroundColor(.black).padding(.horizontal).padding(.vertical, 12.5)
        }
    }
}

