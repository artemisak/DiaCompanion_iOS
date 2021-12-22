//
//  excelManager.swift
//  dia
//
//  Created by Артем  on 15.12.2021.
//

import Foundation
import SQLite

struct FoodRecord {
    var day: Date
    var time: Date
    var foodType: String
    var food:  [String]
    var g: [String]
}

struct TableRecord {
    var day: Date
    var time: [Date]
    var foodType: [String]
    var food:  [[String]]
    var g: [[String]]
}

func getFoodRecords() -> [TableRecord] {
    var record = [FoodRecord]()
    var table = [TableRecord]()
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let foodTable = Table("diary")
        let day = Expression<String>("date")
        let time = Expression<String>("time")
        let foodType = Expression<String>("foodType")
        let foodName = Expression<String>("foodName")
        let gram = Expression<String>("g")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale(identifier: "ru_RU")
        dateFormatter1.setLocalizedDateFormatFromTemplate("HH:mm")
        for i in try db.prepare(foodTable.select(day,time,foodType,foodName,gram)){
            record.append(FoodRecord(day: dateFormatter.date(from: i[day])!, time: dateFormatter1.date(from: i[time])!,foodType: i[foodType], food: [i[foodName]], g: [i[gram]]))
        }
        record = record.sorted(by: {($0.day, $0.time, $0.foodType) < ($1.day, $1.time, $1.foodType)})
        var i = 1
        while i < record.count {
            if record[i].day == record[i-1].day && record[i].time == record[i-1].time && record[i].foodType == record[i-1].foodType {
                record[i].food = record[i-1].food + record[i].food
                record[i].g = record[i-1].g + record[i].g
                record.remove(at: i-1)
            } else {
                i += 1
            }
        }
        
        i = 1
        table.append(TableRecord(day: record[0].day, time: [record[0].time], foodType: [record[0].foodType], food: [record[0].food], g: [record[0].g]))
        while i < record.count {
            if record[i].day == table[i-1].day {
                table[i-1].time.append(record[i].time)
                table[i-1].foodType.append(record[i].foodType)
                table[i-1].food.append(record[i].food)
                table[i-1].g.append(record[i].g)
                record.remove(at: i)
            } else {
                table.append(TableRecord(day: record[i].day, time:[record[i].time], foodType: [record[i].foodType], food:[record[i].food], g:[record[i].g]))
                i += 1
            }
        }
        record.removeAll()
    }
    catch {
        print(error)
    }
    return table
}
