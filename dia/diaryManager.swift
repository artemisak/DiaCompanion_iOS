//
//  FillFoodCategoryList.swift
//  dia
//
//  Created by Артем  on 05.11.2021.
//

import Foundation
import SQLite

struct FoodList: Identifiable, Hashable {
    let name: String
    let id = UUID()
}

class Food: ObservableObject {
    @Published var FoodObj = [FoodList]()
    
    func GetFoodItemsByName(_name: String) -> Void {
        do {
            var Food1 = [FoodList]()
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let foodItems = Table("food")
            let food = Expression<String>("name")
            for i in try db.prepare(foodItems.select(food).filter(food.like("%\(_name)%")).order(food).limit(30)){
                Food1.append(FoodList(name: "\(i[food])"))
            }
            self.FoodObj = Food1
        }
        catch {
            print(error)
        }
    }
    
    func FillFoodCategoryList() async -> Void {
        do {
            var Food1 = [FoodList]()
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let food = Table("foodGroups")
            let category = Expression<String>("category")
            for i in try db.prepare(food.select(category)){
                Food1.append(FoodList(name: "\(i[category])"))
            }
            self.FoodObj = Food1
        }
        catch {
            print(error)
        }
    }
    
    func GetFoodCategoryItems(_category: String) -> [FoodList] {
        do {
            var FoodObj = [FoodList]()
            FoodObj.removeAll()
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let foodItems = Table("food")
            let food = Expression<String>("name")
            let categoryRow = Expression<String>("category")
            for i in try db.prepare(foodItems.select(food).filter(categoryRow == _category)){
                FoodObj.append(FoodList(name: "\(i[food])"))
            }
            return FoodObj
        }
        catch {
            print(error)
            return []
        }
    }
}

func SaveToDB(FoodName: String, gram: String, selectedDate: Date) {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let diary = Table("diary")
        let foodName = Expression<String>("foodName")
        let g = Expression<String>("g")
        let date = Expression<String>("date")
        let time = Expression<String>("time")
        let timeStamp = Expression<String>("timeStamp")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
        let realDateTime = dateFormatter.string(from: Date.now)
        let selectDate = dateFormatter.string(from: selectedDate)
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        let dtime = dateFormatter.string(from: selectedDate)
        try db.run(diary.insert(foodName <- FoodName, g <- gram, date <- selectDate, time <- dtime,timeStamp <- realDateTime))
    }
    catch {
        print(error)
    }
}


