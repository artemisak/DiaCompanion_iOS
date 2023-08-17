//
//  foodPreferences.swift
//  PickerTest
//
//  Created by Артём Исаков on 06.08.2023.
//

import SwiftUI

enum sixTwelve: String, CaseIterable, Identifiable {
    case underSix = "< 6 раз"
    case sixToTwelve = "6-12 раз"
    case aboveTwelve = "> 12 раз"
    var id: Self { self }
}

enum twoFour: String, CaseIterable, Identifiable {
    case underTwo = "< 2 раз"
    case twoToFour = "2-4 раза"
    case aboveFour = "> 4 раз"
    var id: Self { self }
}

enum threeSix: String, CaseIterable, Identifiable {
    case underThree = "< 3 раз"
    case ThreeToSix = "3-6 раз"
    case aboveSix = "> 6 раз"
    var id: Self { self }
}

enum oneTwo: String, CaseIterable, Identifiable {
    case underOne = "< 1 раза"
    case oneToTwo = "1-2 раза"
    case aboveTwo = "> 2 раз"
    var id: Self { self }
}

enum oneThree: String, CaseIterable, Identifiable {
    case underOne = "< 1 раза"
    case oneToThree = "1-3 раза"
    case aboveThree = "> 3 раз"
    var id: Self { self }
}

struct foodPreferences: View {
    @State private var nextField: Bool = false
    @State private var fruitsBefore: sixTwelve = sixTwelve.underSix
    @State private var fruitsAfter: sixTwelve = sixTwelve.sixToTwelve
    @State private var bisquitsBefore: twoFour = twoFour.underTwo
    @State private var bisquitsAfter: twoFour = twoFour.twoToFour
    @State private var bakingBefore: twoFour = twoFour.underTwo
    @State private var bakingAfter: twoFour = twoFour.twoToFour
    @State private var chocolateBefore: twoFour = twoFour.underTwo
    @State private var chocolateAfter: twoFour = twoFour.twoToFour
    @State private var milkBefore: threeSix = threeSix.underThree
    @State private var milkAfter: threeSix = threeSix.ThreeToSix
    @State private var milkBefore_alt: threeSix = threeSix.underThree
    @State private var milkAfter_alt: threeSix = threeSix.ThreeToSix
    @State private var legumesBefore: oneTwo = oneTwo.underOne
    @State private var legumesAfter: oneTwo = oneTwo.oneToTwo
    @State private var meatBefore: threeSix = threeSix.ThreeToSix
    @State private var meatAfter: threeSix = threeSix.underThree
    @State private var driedFruitsBefore: oneThree = oneThree.underOne
    @State private var driedFruitsAfter: oneThree = oneThree.oneToThree
    @State private var fishBefore: threeSix = threeSix.ThreeToSix
    @State private var fishAfter: threeSix = threeSix.underThree
    @State private var grainBreadBefore: oneThree = oneThree.underOne
    @State private var grainBreadAfter: oneThree = oneThree.oneToThree
    @State private var anyBreadBefore: sixTwelve = sixTwelve.underSix
    @State private var anyBreadAfter: sixTwelve = sixTwelve.sixToTwelve
    @State private var sauceBefore: twoFour = twoFour.underTwo
    @State private var sauceAfter: twoFour = twoFour.twoToFour
    @State private var vegetableBefore: sixTwelve = sixTwelve.underSix
    @State private var vegetableAfter: sixTwelve = sixTwelve.sixToTwelve
    @State private var alcoholBefore: oneThree = oneThree.underOne
    @State private var alcoholAfter: oneThree = oneThree.oneToThree
    @State private var sweetDrinksBefore: twoFour = twoFour.underTwo
    @State private var sweetDrinksAfter: twoFour = twoFour.twoToFour
    @State private var coffeBefore: oneThree = oneThree.underOne
    @State private var coffeAfter: oneThree = oneThree.oneToThree
    @State private var sausagesBefore: oneThree = oneThree.underOne
    @State private var sausagesAfter: oneThree = oneThree.oneToThree
    var body: some View {
            Form {
                Text("Укажите частоту потребления продуктов в неделю").font(.title2).listRowBackground(Spacer()).listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                Group {
                    Section {
                        Picker("До беременности", selection: $fruitsBefore) {
                            ForEach(sixTwelve.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $fruitsAfter) {
                            ForEach(sixTwelve.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Фркуты").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $bisquitsBefore) {
                            ForEach(twoFour.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $bisquitsAfter) {
                            ForEach(twoFour.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Пирожные").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $bakingBefore) {
                            ForEach(twoFour.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $bakingAfter) {
                            ForEach(twoFour.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Выпечка").font(.title3)
                    }
                    
                    Section {
                        Picker("До беременности", selection: $chocolateBefore) {
                            ForEach(twoFour.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $chocolateAfter) {
                            ForEach(twoFour.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Шоколад").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $milkBefore) {
                            ForEach(threeSix.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $milkAfter) {
                            ForEach(threeSix.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Обезжиренные молочные продукты").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $milkBefore_alt) {
                            ForEach(threeSix.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $milkAfter_alt) {
                            ForEach(threeSix.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Не обезжиренные молочные продукты").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $legumesBefore) {
                            ForEach(oneTwo.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $legumesAfter) {
                            ForEach(oneTwo.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Бобовые").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $meatBefore) {
                            ForEach(threeSix.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $meatAfter) {
                            ForEach(threeSix.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Мясо и мясные изделия").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $driedFruitsBefore) {
                            ForEach(oneThree.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $driedFruitsAfter) {
                            ForEach(oneThree.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Сухофрукты").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $fishBefore) {
                            ForEach(threeSix.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $fishAfter) {
                            ForEach(threeSix.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Рыба и рыбные изделия").font(.title3)
                    }
                }
                Group {
                    Section {
                        Picker("До беременности", selection: $grainBreadBefore) {
                            ForEach(oneThree.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $grainBreadAfter) {
                            ForEach(oneThree.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Цельнозреновой хлеб").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $anyBreadBefore) {
                            ForEach(sixTwelve.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $anyBreadAfter) {
                            ForEach(sixTwelve.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Любой хлеб").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $sauceBefore) {
                            ForEach(twoFour.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $sauceAfter) {
                            ForEach(twoFour.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Cоусы, майонез").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $vegetableBefore) {
                            ForEach(sixTwelve.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $vegetableAfter) {
                            ForEach(sixTwelve.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Овощи, сырые или приготовленные").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $alcoholBefore) {
                            ForEach(oneThree.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $alcoholAfter) {
                            ForEach(oneThree.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Алкоголь").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $sweetDrinksBefore) {
                            ForEach(twoFour.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $sweetDrinksAfter) {
                            ForEach(twoFour.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Сладкие напитки").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $coffeBefore) {
                            ForEach(oneThree.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $coffeAfter) {
                            ForEach(oneThree.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Кофе").font(.title3)
                    }
                    Section {
                        Picker("До беременности", selection: $sausagesBefore) {
                            ForEach(oneThree.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                        Picker("Во время беременности", selection: $sausagesAfter) {
                            ForEach(oneThree.allCases) {i in
                                Text(i.rawValue).tag(i)
                            }
                        }
                    } header: {
                        Text("Сосики, колбаса").font(.title3)
                    }
                }
            }
            .navigationTitle("Предпочтения")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack {
                        NavigationLink(isActive: $nextField, destination: {activityPreferences()}, label: {EmptyView()}).buttonStyle(TransparentButton()).hidden()
                        Button {
                            Task {
                                await questionaryManager.provider.saveFoodPrefrences(fruits_before: fruitsBefore.rawValue, fruits_after: fruitsAfter.rawValue, bisquits_before: bisquitsBefore.rawValue, bisquits_after: bisquitsAfter.rawValue, baking_before: bakingBefore.rawValue, baking_after: bakingAfter.rawValue, chocolate_before: chocolateBefore.rawValue, chocolate_after: chocolateAfter.rawValue, milk_before: milkBefore.rawValue, milk_after: milkAfter.rawValue, milk_before_alt: milkBefore_alt.rawValue, milk_after_alt: milkAfter_alt.rawValue, legumes_before: legumesBefore.rawValue, legumes_after: legumesAfter.rawValue, meat_before: meatBefore.rawValue, meat_after: meatAfter.rawValue, dried_fruits_before: driedFruitsBefore.rawValue, dried_fruits_after: driedFruitsAfter.rawValue, fish_before: fishBefore.rawValue, fish_after: fishAfter.rawValue, grain_bread_before: grainBreadBefore.rawValue, grain_bread_after: grainBreadAfter.rawValue, any_bread_before: anyBreadBefore.rawValue, any_bread_after: anyBreadAfter.rawValue, sauce_before: sauceBefore.rawValue, sauce_after: sauceAfter.rawValue, vegetable_before: vegetableBefore.rawValue, vegetable_after: vegetableAfter.rawValue, alcohol_before: alcoholBefore.rawValue, alcohol_after: alcoholAfter.rawValue, sweet_drinks_before: sweetDrinksBefore.rawValue, sweet_drinks_after: sweetDrinksAfter.rawValue, coffe_before: coffeBefore.rawValue, coffe_after: coffeAfter.rawValue, sausages_before: sausagesBefore.rawValue, sausages_after: sausagesAfter.rawValue)
                                nextField = true
                            }
                        } label: {
                            Text("Далее")
                        }
                    }
                }
            }
    }
}

struct foodPreferences_Previews: PreviewProvider {
    static var previews: some View {
        foodPreferences()
    }
}
