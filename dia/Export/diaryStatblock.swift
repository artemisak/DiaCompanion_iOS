//
//  diaryStatblock.swift
//  dia
//
//  Created by Артём Исаков on 29.01.2023.
//

import Foundation
import SQLite3

struct sugarRow: Identifiable, Hashable {
    var id = UUID()
    var lvl: Double
    var period: String
    var dateTime: Date
}

struct foodRow: Identifiable, Hashable {
    var id = UUID()
    var timeStamp: Date
    var dateTime: Date
    var meals: String
    var carbo: Double
}

class diaryStatblock: ObservableObject {
    static let statBlock = diaryStatblock()
    var sugarRecords = [sugarRow]()
    var foodRecords = [foodRow]()
    var bg_total: Int = 0
    var bg_high_fasting: Int = 0
    var bg_high_food: Int = 0
    var bg_bad_ppgr: Int = 0
    var all_meals: Double = 0.0
    var snacks: Double = 0.0
    var on_time: Double = 0.0
    var meals_main: Double = 0.0
    var meals_on_time: Double = 0.0
    
    func checkDiary() {
        sugarRecords = getSugarRecords().filter({$0.dateTime <= Date.now && $0.dateTime >= Date.now.addingTimeInterval(-60*60*24*7)})
        foodRecords = getFoodRecords().filter({$0.dateTime <= Date.now && $0.dateTime >= Date.now.addingTimeInterval(-60*60*24*7)})
        
        for i in sugarRecords {
            bg_total += 1
            if i.period == "Натощак" && i.lvl > 5.1 {bg_high_fasting += 1}
            else if i.period != " Натощак" && i.lvl > 7.0 {
                bg_high_food += 1
                if checkPPGR(dateTime: i.dateTime) {bg_bad_ppgr += 1}
            }
        }
        
        for i in foodRecords {
            all_meals += 1.0
            if i.meals == "Перекус" {snacks += 1.0}
            if abs(i.timeStamp.timeIntervalSince(i.dateTime)) < TimeInterval(60*60) {on_time += 1.0}
        }
        meals_main = (all_meals == 0) ? 0 : round((all_meals - snacks) / all_meals * 100)
        meals_on_time = (all_meals == 0) ? 0 : round(on_time / all_meals * 100)
    }
    
    func checkPPGR(dateTime: Date) -> Bool {
        let upperBound = dateTime.addingTimeInterval(-60*75)
        let lowerBound = dateTime.addingTimeInterval(-60*45)
        var food_intakes: Int = 0
        var carbos: Double = 0.0
        for i in foodRecords {
            if i.dateTime > lowerBound && i.dateTime < upperBound {
                food_intakes += 1
                carbos += i.carbo
            }
        }
        return (food_intakes > 0 && carbos < 30)
    }
    
    func formMailBoodyMessage(version: Int) -> String {
        if version != 4 {
            return "За последние 7 дней превышений УГК выше целевого: </br>" +
            "Натощак: \(bg_high_fasting) </br>" +
            "После еды: \(bg_high_food) </br>" +
            "Основные приемы пищи: \(meals_main) % \(all_meals - snacks) / \(all_meals) </br>" +
            "Записаны при приеме пищи: \(meals_on_time) % \(on_time) / \(all_meals) </br>"
        } else {
            return "Основные приемы пищи: \(meals_main) % \(all_meals - snacks) / \(all_meals) </br>" +
            "Записаны при приеме пищи: \(meals_on_time) % \(on_time) / \(all_meals) </br>"
        }
    }
    
    func formMailSubject(version: Int) -> String {
        let id = patientManager.provider.getPreloadID()
        let fio = patientManager.provider.getPreloadFIO()
        let versionName = patientManager.provider.getVersionName(number: version)
        if (bg_bad_ppgr > 1) {
            return "!!\(versionName) \(id) \(fio) - Дневник наблюдения"
        } else if bg_total > 0 && ((bg_high_fasting + bg_high_food) / bg_total > 1/3) {
            return "!\(versionName) \(id) \(fio) - Дневник наблюдения"
        }
        return "\(versionName) \(id) \(fio) - Дневник наблюдения"
    }
        
    func getFoodRecords() -> [foodRow] {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        
        var db: OpaquePointer?
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("Error opening database")
            sqlite3_close(db)
            db = nil
            return []
        }
        
        var statement: OpaquePointer?
        
        let df = DateFormatter()
        df.dateFormat = "HH:mm dd.MM.yyyy"
        let df_alt = DateFormatter()
        df_alt.dateFormat = "dd.MM.yyyy,HH:mm"
        
        let sql = "SELECT timeStamp, dateTime, foodType AS meals, sum(g*carbo/100) AS carbo FROM diary LEFT JOIN food ON diary.id_food = food._id GROUP BY timeStamp, date, time, foodType"
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
        }
        
        var allFoodRecords = [foodRow]()
        while sqlite3_step(statement) == SQLITE_ROW {
            allFoodRecords.append(foodRow(timeStamp: df_alt.date(from: String(cString: sqlite3_column_text(statement, 0)))!, dateTime: df.date(from: String(cString: sqlite3_column_text(statement, 1)))!, meals: String(cString: sqlite3_column_text(statement, 2)), carbo: sqlite3_column_double(statement, 3)))
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
        
        return allFoodRecords
    }
    
    func getSugarRecords() -> [sugarRow] {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        
        var db: OpaquePointer?
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("Error opening database")
            sqlite3_close(db)
            db = nil
            return []
        }
        
        var statement: OpaquePointer?
        let df = DateFormatter()
        df.dateFormat = "HH:mm dd.MM.yyyy"
        let sql = "SELECT lvl, period, time FROM sugarChange"
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
        }
        
        var allSugarRecords = [sugarRow]()
        while sqlite3_step(statement) == SQLITE_ROW {
            allSugarRecords.append(sugarRow(lvl: sqlite3_column_double(statement, 0), period: String(cString: sqlite3_column_text(statement, 1)), dateTime: df.date(from: String(cString: sqlite3_column_text(statement, 2)))!))
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
        
        return allSugarRecords
    }
}
