//
//  addCustomMeal.swift
//  dia
//
//  Created by Артём Исаков on 12.09.2022.
//

import SwiftUI

enum cat: String, CaseIterable, Identifiable {
    case alcohol = "Алкогольные напитки"
    case potato = "Блюда из картофеля, овощей и грибов"
    case croup = "Блюда из круп"
    case meat = "Блюда из мяса и мясных продуктов"
    case fish = "Блюда из рыбы, морепродуктов и раков"
    case curd = "Блюда из творога"
    case eggs = "Бдюда из яиц"
    case nuts = "Бобовые, орехи, продукты из бобовых"
    case fastMeal = "Быстрое питание"
    case additionalItems = "Вспомогательные продукты"
    case garnish = "Гарниры"
    case cookedMeal = "Готовые завтраки"
    case kidsMeal = "Детское питание"
    case diabeticItems = "Диабетические продукты"
    case oilAndFat = "Жиры и масла"
    case snacks = "Закуски"
    case greenAndVegetables = "Зелень и овощные продукты"
    case grain = "Зерно, мука"
    case pasta = "Злаки и макароны"
    case breakfastGrains = "Злаки на завтрак"
    case sausages =  "Колбасы"
    case bakery = "Кондитерские изделия"
    case chocolate = "Конфеты, шоколад"
    case milkAndEggs = "Молочные и яичные продукты"
    case milk = "Молочные продукты"
    case seafood = "Морепродукты"
    case meatItems = "Мясо и мясные продуты"
    case drinks = "Напитки"
    case vegetables = "Овощи"
    case folksMeal = "Пища коренных народов"
    case beef = "Продукты из говядины"
    case nutsProduce = "Продукты из орехов и семян"
    case chikenProducce = "Продуты из птицы"
    case pigProduce = "Продукты из свинины"
    case lamb = "Продукты из баранины, телятины и дичи"
    case restaurantFood = "Ресторанная еда"
    case fishAndFishItems = "Рыба и рыбные продукты"
    case sweetes = "Сладости"
    case sausagesAndMeatFood = "Сосиски и мясные блюда"
    case sauce = "Соусы"
    case spice = "Специи и травы"
    case soup = "Супы"
    case cheese = "Сыры"
    case fruits = "Фрукты и фруктовые соки"
    case bread = "Хлебобулочные изделия"
    case coldMeal = "Холодные блюда"
    case barries = "Ягоды, варенье"
    var id : Self { self }
}

struct addCustomMeal: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedCat = cat.alcohol
    @State private var foodNotation: String = ""
    @State private var showSheet: Bool = false
    @State private var foodItems: [foodToSave] = []
    @State private var errorMessage: String = "Заполните поля в соотвествии с требованиями"
    @State private var permission: Bool = false
    @FocusState private var focus: Bool
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        List {
            Section(header: Text("Общая информация").font(.system(size: 15.5))){
                TextField("Название блюда", text: $foodNotation)
                    .focused($focus)
                    .autocorrectionDisabled()
                NavigationLink(destination: categoryPicker(selectedCat: $selectedCat)) {
                    Text(selectedCat.rawValue)
                }
            }
            Section(header: Text("Составляющие рецепта").font(.system(size: 15.5))){
                Button {
                    showSheet.toggle()
                } label: {
                    HStack{
                        Text("Добавить ингредиент")
                        Image(systemName: "folder.badge.plus")
                    }
                }
                .sheet(isPresented: $showSheet) {
                    addFoodButton(foodItems: $foodItems, txtTheme: $txtTheme).dynamicTypeSize(txtTheme)
                }
            }
            Section {
                ForEach(foodItems, id: \.id){ i in
                    let arg = "\(i.name)".components(separatedBy: "////")
                    Text("\(arg[0]), \(arg[1]) г.")
                }.onDelete(perform: removeRow)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    do {
                        addNewFoodN(items: try checkIsEmpty(items: foodItems), newReceitName: try checkName(txt: foodNotation), category: selectedCat.rawValue)
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
        .alert(isPresented: $permission) {
            Alert(title: Text("Статус операции"), message: Text(errorMessage), dismissButton: .default(Text("ОК")))
        }
        .navigationTitle("Рецепты")
    }
    func removeRow(at offsets: IndexSet){
        foodItems.remove(atOffsets: offsets)
    }
}

struct categoryPicker : View {
    @Binding var selectedCat: cat
    var body: some View {
        List {
            Picker(selection: $selectedCat, label: Text("Категория продукта").font(.system(size: 15.5))){
                ForEach(cat.allCases){ obj in
                    Text(obj.rawValue)
                }
            }.pickerStyle(.inline)
        }
    }
}

func checkIsEmpty(items: [foodToSave]) throws -> [foodToSave] {
    guard !items.isEmpty else {
        throw inputErorrs.EmptyError
    }
    return items
}
