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
var FoodList: [FoodCategory] = []

func FillFoodCategoryList() -> [FoodCategory] {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let food = Table("foodGroups")
        let category = Expression<String>("category")
        for i in try db.prepare(food.select(category)){
            FoodList.append(FoodCategory(name: "\(i[category])"))
        }
    }
    catch {
        print(error)
    }
    return FoodList
}

