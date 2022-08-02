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
    @StateObject private var items = Food()
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0){
                        Divider()
                        TextField("Поиск по слову", text: $selectedFood)
                            .disableAutocorrection(true)
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
                        if !searchByWordView {
                            ForEach(items.FoodObj.sorted(by: {$0.rating > $1.rating}), id: \.id){dish in
                                DoButton(dish: dish)
                                Divider()
                            }
                        } else {
                            ForEach(items.CatObj, id: \.id){ dish in
                                DoLink(dish: dish)
                                Divider()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .ignoresSafeArea(.keyboard)
                if addScreen {
                    addSreenView(foodList: items, addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodTemp, rating: $selectedFoodTempRating, foodItems: $foodItems)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Добавить блюдо")
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
                await items.FillFoodCategoryList()
            }
            .interactiveDismissDisabled()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    func GetFoodCategoryItemsView(category: String) -> some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0){
                    Divider()
                    TextField("Поиск по слову", text: $selectedFoodCategoryItem)
                        .disableAutocorrection(true)
                        .padding(.vertical, 10)
                    Divider()
                    ForEach(items.FoodObj.filter{$0.name.contains(selectedFoodCategoryItem) || selectedFoodCategoryItem.isEmpty}.sorted(by: {$0.rating > $1.rating}), id: \.id){dish in
                        DoButton(dish: dish)
                        Divider()
                    }
                }.padding(.horizontal, 20)
            }
            .ignoresSafeArea(.keyboard)
            if addScreen {
                addSreenView(foodList: items, addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodTemp, rating: $selectedFoodTempRating, foodItems: $foodItems)
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
        .onAppear(perform: {
            items.GetFoodCategoryItems(_category: category)
        })
    }
    
    @ViewBuilder
    func DoButton(dish: FoodList) -> some View {
        Button(action: {
            selectedFoodTemp = dish.name
            selectedFoodTempRating = dish.rating
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {addScreen = true})
        }){
            HStack{
                Text("\(dish.name)").frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                HStack{
                VStack{
                    Text("Б")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 13))
                    Text("\(dish.prot)").foregroundColor(.orange)
                }
                VStack{
                    Text("Ж")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 13))
                    Text("\(dish.fat)").foregroundColor(.green)
                }
                VStack{
                    Text("У")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 13))
                    Text("\(dish.carbo)").foregroundColor(.blue)
                }
                VStack{
                    Text("ГИ")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 13))
                    Text("\(dish.gi)").foregroundColor(.red)
                }
                }.frame(minWidth: 0, maxWidth: .infinity)
            }
        }
        .buttonStyle(TransparentButtonAndLink())
        .background(dish.rating == 0 ? nil : Color.green.opacity(0.3))
    }
    
    @ViewBuilder
    func DoLink(dish: CategoryList) -> some View {
        NavigationLink(destination: GetFoodCategoryItemsView(category: "\(dish.name)")) {
            Text("\(dish.name)")
        }
        .buttonStyle(TransparentButtonAndLink())
    }
}
