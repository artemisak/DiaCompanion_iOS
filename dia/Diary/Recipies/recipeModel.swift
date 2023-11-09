//
//  recipeManager.swift
//  dia
//
//  Created by Артём Исаков on 20.01.2023.
//

import Foundation
import SQLite3

struct recipeDetails: Identifiable, Hashable {
    var id = UUID()
    var table_id: Int
    var name: String
    var url: String
    var item_id: [Int]
    var item_name: [String]
    var prot: [Double]
    var fat: [Double]
    var carbo: [Double]
    var kkal: [Double]
    var gi: [Double]
    var gram: [Double]
}

struct recipe: Identifiable, Hashable {
    var id = UUID()
    var item: String
    var table_id: Int
    var gram: Double
}

class recipeModel: ObservableObject {
    @Published var recipes: [recipeDetails] = []
    
    func fillRecipes() {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        
        var db: OpaquePointer?
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("Error opening database")
            sqlite3_close(db)
            db = nil
            return
        }
        
        var statement: OpaquePointer?
        let sql = "SELECT _id AS id, name, url, group_concat(item_id) AS item_id, group_concat(item_name, '//') AS item_name, group_concat(prot) AS prot, group_concat(fat) AS fat, group_concat(carbo) AS carbo, group_concat(kkal) AS kkal, group_concat(gi) AS gi, group_concat(gram) AS gram FROM (SELECT _id, name, url, item_id, (SELECT name FROM food INNER JOIN usersRecipes ON food._id = tab1.item_id) as item_name, (SELECT prot FROM food INNER JOIN usersRecipes ON food._id = tab1.item_id) as prot, (SELECT fat FROM food INNER JOIN usersRecipes ON food._id = tab1.item_id) as fat, (SELECT carbo FROM food INNER JOIN usersRecipes ON food._id = tab1.item_id) as carbo, (SELECT ec FROM food INNER JOIN usersRecipes ON food._id = tab1.item_id) as kkal, (SELECT gi FROM food INNER JOIN usersRecipes ON food._id = tab1.item_id) as gi, gram FROM (SELECT _id, name, url, item_id, gram FROM food INNER JOIN usersRecipes ON food._id = usersRecipes.food_id) AS tab1) GROUP BY _id"
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
        }
        
        var temp: [recipeDetails] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int64(statement, 0))
            let name = String(cString: sqlite3_column_text(statement, 1))
            let url = String(cString: sqlite3_column_text(statement, 2))
            let item_id = String(cString: sqlite3_column_text(statement, 3)).components(separatedBy: ",").compactMap(Int.init)
            let item_name = String(cString: sqlite3_column_text(statement, 4)).components(separatedBy: "//")
            let prot = String(cString: sqlite3_column_text(statement, 5)).components(separatedBy: ",").compactMap(Double.init)
            let fat = String(cString: sqlite3_column_text(statement, 6)).components(separatedBy: ",").compactMap(Double.init)
            let carbo = String(cString: sqlite3_column_text(statement, 7)).components(separatedBy: ",").compactMap(Double.init)
            let kkal = String(cString: sqlite3_column_text(statement, 8)).components(separatedBy: ",").compactMap(Double.init)
            let gi = String(cString: sqlite3_column_text(statement, 9)).components(separatedBy: ",").compactMap(Double.init)
            let gram = String(cString: sqlite3_column_text(statement, 10)).components(separatedBy: ",").compactMap(Double.init)
            temp.append(recipeDetails(table_id: id, name: name, url: url, item_id: item_id, item_name: item_name, prot: prot, fat: fat, carbo: carbo, kkal: kkal, gi: gi, gram: gram))
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error finalizing prepared statement: \(errmsg)")
        }
        statement = nil
        
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
        db = nil
        
        recipes = temp
    }
    
    func deleteRecipe(item: recipeDetails) {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        
        var db: OpaquePointer?
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("Error opening database")
            sqlite3_close(db)
            db = nil
            return
        }
        
        var statement: OpaquePointer?
        let sql = "DELETE FROM food WHERE _id = \(item.table_id); DELETE FROM usersRecipes WHERE food_id = \(item.table_id); DELETE FROM diary WHERE id_food = \(item.table_id);"
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Erorr deleting elements")
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error finalizing prepared statement: \(errmsg)")
        }
        statement = nil
        
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
        db = nil
    }
    
}
