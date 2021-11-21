//
//  FillFoodCategoryList.swift
//  dia
//
//  Created by Артем  on 05.11.2021.
//

import Foundation
import SwiftUI
import SQLite

struct FoodList: Identifiable, Hashable {
    let name: String
    let id = UUID()
}

func FillFoodCategoryList() -> [FoodList] {
    do {
        var catList: [FoodList] = []
        catList.removeAll()
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let food = Table("foodGroups")
        let category = Expression<String>("category")
        for i in try db.prepare(food.select(category)){
            catList.append(FoodList(name: "\(i[category])"))
        }
        return catList
    }
    catch {
        print(error)
        return []
    }
}

func GetFoodItemsByName(_name: String) -> [FoodList] {
    do {
        var foodItemsByName: [FoodList] = []
        foodItemsByName.removeAll()
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let foodItems = Table("food")
        let food = Expression<String>("name")
        for i in try db.prepare(foodItems.select(food).filter(food.like("%\(_name)%")).order(food)){
            foodItemsByName.append(FoodList(name: "\(i[food])"))
        }
        return foodItemsByName
    }
    catch {
        print(error)
        return []
    }
}

func GetFoodCategoryItems(_category: String) -> [FoodList] {
    do {
        var foodCategoryItems: [FoodList] = []
        foodCategoryItems.removeAll()
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
            foodCategoryItems.append(FoodList(name: "\(i[food])"))
        }
        return foodCategoryItems
    }
    catch {
        print(error)
        return []
    }
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


