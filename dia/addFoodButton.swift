import SwiftUI

struct addFoodButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var foodItems: [String]
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
                VStack(spacing: 0) {
                    HStack {
                        TextField(text: $selectedFood, prompt: Text("Поиск по слову"), label: {EmptyView()}).disableAutocorrection(true)
                        Image(systemName: "xmark").foregroundColor(Color(red: 87/255, green: 165/255, blue: 248/255))
                            .onTapGesture {
                                selectedFood = ""
                            }
                    }
                    .padding(.vertical, 13.5)
                    .padding(.horizontal, 16)
                    .border(Color(red: 233/255, green: 233/255, blue: 234/255), width: 1)
                    .padding(.bottom, -0.5)
                    .zIndex(2)
                    if searchByWordView {
                        List(items.CatObj, id: \.id){dish in
                            DoLink(dish: dish)
                        }
                        .ignoresSafeArea(.keyboard)
                        .listStyle(.plain)
                        .zIndex(1)
                    } else {
                        List(items.FoodObj.sorted(by: {$0.rating > $1.rating}), id: \.id) {dish in
                            DoButton(dish: dish)
                                .contextMenu {
                                    Button(action: {
                                        if items.FoodObj[items.FoodObj.firstIndex(where: {$0.name == dish.name})!].rating == 0 {
                                            items.FoodObj[items.FoodObj.firstIndex(where: {$0.name == dish.name})!].rating = 1
                                        } else {
                                            items.FoodObj[items.FoodObj.firstIndex(where: {$0.name == dish.name})!].rating = 0
                                        }
                                        changeRating(_name: dish.name, _rating: dish.rating)
                                        items.foodId = UUID()
                                    }, label: {
                                        HStack {
                                            Text(dish.rating == 0 ? "Добавить в избранное" : "Удалить из избранного")
                                            Image(systemName: dish.rating == 0 ? "star" : "star.fill")
                                        }
                                    })
                                }
                        }
                        .id(items.foodId)
                        .ignoresSafeArea(.keyboard)
                        .listStyle(.plain)
                        .zIndex(1)
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
                items.FillFoodCategoryList()
            }
            .onChange(of: selectedFood, perform: {selectedFood in
                if !selectedFood.isEmpty {
                    searchByWordView = false
                    items.foodId = UUID()
                    items.GetFoodItemsByName(_name: selectedFood)
                } else {
                    searchByWordView = true
                    items.FillFoodCategoryList()
                }
            })
            .onChange(of: successedSave, perform: {i in
                if i {
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
            VStack(spacing: 0) {
                HStack {
                    TextField(text: $selectedFoodCategoryItem, prompt: Text("Поиск по слову"), label: {EmptyView()}).disableAutocorrection(true)
                    Image(systemName: "xmark").foregroundColor(Color(red: 87/255, green: 165/255, blue: 248/255))
                        .onTapGesture {
                            selectedFoodCategoryItem = ""
                        }
                }
                .padding(.vertical, 13.5)
                .padding(.horizontal, 16)
                .border(Color(red: 233/255, green: 233/255, blue: 234/255), width: 1)
                .padding(.bottom, -0.5)
                .zIndex(2)
                List(items.FoodObj.filter{$0.name.contains(selectedFoodCategoryItem) || selectedFoodCategoryItem.isEmpty}.sorted(by: {$0.rating > $1.rating}), id: \.id){dish in
                    DoButton(dish: dish)
                        .contextMenu {
                            Button(action: {
                                if items.FoodObj[items.FoodObj.firstIndex(where: {$0.name == dish.name})!].rating == 0 {
                                    items.FoodObj[items.FoodObj.firstIndex(where: {$0.name == dish.name})!].rating = 1
                                } else {
                                    items.FoodObj[items.FoodObj.firstIndex(where: {$0.name == dish.name})!].rating = 0
                                }
                                changeRating(_name: dish.name, _rating: dish.rating)
                                items.catId = UUID()
                            }, label: {
                                HStack {
                                    Text(dish.rating == 0 ? "Добавить в избранное" : "Удалить из избранного")
                                    Image(systemName: dish.rating == 0 ? "star" : "star.fill")
                                }
                            })
                        }
                }
                .id(items.catId)
                .ignoresSafeArea(.keyboard)
                .listStyle(.plain)
                .zIndex(1)
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
        .onChange(of: selectedFoodCategoryItem, perform: {i in
            items.catId = UUID()
        })
        .onChange(of: successedSave, perform: {i in
            if i {
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
                HStack{
                    VStack{
                        Text("Б")
                            .foregroundColor(Color.gray)
                        Text("\(dish.prot)").foregroundColor(.orange)
                    }.font(.system(size: 18.5))
                    VStack{
                        Text("Ж")
                            .foregroundColor(Color.gray)
                        Text("\(dish.fat)").foregroundColor(.green)
                    }.font(.system(size: 18.5))
                    VStack{
                        Text("У")
                            .foregroundColor(Color.gray)
                        Text("\(dish.carbo)").foregroundColor(.blue)
                    }.font(.system(size: 18.5))
                    VStack{
                        Text("ГИ")
                            .foregroundColor(Color.gray)
                        Text("\(dish.gi)").foregroundColor(.red)
                    }.font(.system(size: 18.5))
                }
                Text("\(dish.name)").frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).font(.system(size: 20))
            }
        }
        .listRowBackground(dish.rating == 0 ? nil : Color.green.opacity(0.3))
    }
    
    @ViewBuilder
    func DoLink(dish: CategoryList) -> some View {
        NavigationLink(destination: GetFoodCategoryItemsView(category: "\(dish.name)")) {
            Text("\(dish.name)")
        }
    }
}

