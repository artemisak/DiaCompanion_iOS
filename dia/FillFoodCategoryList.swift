//
//  FillFoodCategoryList.swift
//  dia
//
//  Created by Артем  on 05.11.2021.
//

import Foundation
import SwiftUI
import SQLite

struct FoodCategory: Identifiable, Hashable {
    let name: String
    let id = UUID()
}

func FillFoodCategoryList() async throws -> [FoodCategory] {
    var catList: [FoodCategory] = []
    do {
        catList.removeAll()
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let food = Table("foodGroups")
        let category = Expression<String>("category")
        for i in try db.prepare(food.select(category)){
            catList.append(FoodCategory(name: "\(i[category])"))
        }
    }
    catch {
        print(error)
    }
    return catList
}

struct FoodItemByName: Identifiable, Hashable {
    let name: String
    let id = UUID()
}

func GetFoodItemsByName(_name: String) async throws-> [FoodItemByName] {
    var foodItemsByName: [FoodItemByName] = []
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let foodItems = Table("food")
        let food = Expression<String>("name")
        foodItemsByName.removeAll()
        for i in try db.prepare(foodItems.select(food).filter(food.like("%\(_name)%")).order(food)){
            foodItemsByName.append(FoodItemByName(name: "\(i[food])"))
        }
    }
    catch {
        print(error)
    }
    return foodItemsByName
}

struct FoodCategoryItem: Identifiable, Hashable {
    let name: String
    let id = UUID()
}

func GetFoodCategoryItems(_category: String) -> [FoodCategoryItem] {
    var foodCategoryItems: [FoodCategoryItem] = []
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let foodItems = Table("food")
        let food = Expression<String>("name")
        let categoryRow = Expression<String>("category")
        foodCategoryItems.removeAll()
        for i in try db.prepare(foodItems.select(food).filter(categoryRow == _category)){
            foodCategoryItems.append(FoodCategoryItem(name: "\(i[food])"))
        }
    }
    catch {
        print(error)
    }
    return foodCategoryItems
}

func SaveToDB(FoodName: String, gramm: String) {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let diary = Table("diary")
        let foodName = Expression<String>("foodName")
        let g = Expression<String>("g")
        let dateTime = Expression<String>("dateTime")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
        let DateTime = dateFormatter.string(from: Date.now)
        try db.run(diary.insert(foodName <- FoodName, g <- gramm, dateTime <- DateTime))
    }
    catch {
        print(error)
    }
}
