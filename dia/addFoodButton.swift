import SwiftUI

struct addFoodButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var foodItems: [String]
    @State public var addScreen: Bool = true
    @State public var selectedFoodTemp: String = ""
    @State public var selectedFoodCategoryTemp: String = ""
    @State public var gram: String = ""
    @State private var selectedFood: String = ""
    @State private var selectedFoodCategoryItem: String = ""
    @State private var searchByWordView: Bool = true
    @State private var searchByWordCategoryView: Bool = true
    @StateObject private var items = Food()
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0){
                    Divider()
                    TextField("Поиск по слову", text: $selectedFood)
                        .padding(.vertical, 10)
                        .onChange(of: selectedFood, perform: {selectedFood in
                            if !selectedFood.isEmpty {
                                items.GetFoodItemsByName(_name: selectedFood)
                                searchByWordView = false
                            } else {
                                Task {
                                    await items.FillFoodCategoryList()
                                    searchByWordView = true
                                }
                            }
                        })
                    Divider()
                    ForEach(items.FoodObj, id: \.id){dish in
                        if !searchByWordView {
                            DoButton(dish: dish)
                            Divider()
                        } else {
                            DoLink(dish: dish)
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .task {
                await items.FillFoodCategoryList()
            }
            .navigationTitle("Добавить блюдо")
            .navigationBarTitleDisplayMode(.large)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Закрыть")
                    }
                })
                ToolbarItem(placement: .keyboard, content: {
                    HStack{
                        Spacer()
                        Button(action: {
                            UIApplication.shared.dismissedKeyboard()
                        }, label: {
                            Text("Готово")
                        })
                    }
                })
            }
        }
        .overlay(addScreen ? nil : addSreenView(addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodTemp, foodItems: $foodItems))
    }
    
    func DoButton(dish: FoodList) -> some View {
        Button(action: {
            UIApplication.shared.dismissedKeyboard()
            selectedFoodTemp = dish.name
            addScreen.toggle()
        }){
            Text("\(dish.name)")
        }
        .buttonStyle(TransparentButtonAndLink())
    }
    
    func DoLink(dish: FoodList) -> some View {
        NavigationLink(destination: GetFoodCategoryItemsView(category: "\(dish.name)")) {
            Text("\(dish.name)")
        }
        .buttonStyle(TransparentButtonAndLink())
    }
    
    func GetFoodCategoryItemsView(category: String) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0){
                Divider()
                TextField("Поиск по слову", text: $selectedFoodCategoryItem).padding(.vertical, 10)
                Divider()
                ForEach(items.GetFoodCategoryItems(_category: category).filter{$0.name.contains(selectedFoodCategoryItem) || selectedFoodCategoryItem.isEmpty}, id: \.id){dish in
                    DoButton(dish: dish)
                    Divider()
                }
            }.padding(.horizontal, 20)
        }
        .listStyle(.plain)
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .keyboard, content: {
                HStack{
                    Spacer()
                    Button(action: {
                        UIApplication.shared.dismissedKeyboard()
                    }, label: {
                        Text("Готово")
                    })
                }
            })
        }
    }
}

struct addFoodButton_Previews: PreviewProvider {
    static var previews: some View {
        addFoodButton(foodItems: .constant([]))
    }
}

