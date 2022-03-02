//
//  pacientButton.swift
//  dia
//
//  Created by Артем  on 27.09.2021.
//

import Foundation
import SQLite

func addName(pName: String){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let users = Table("usermac")
        let name = Expression<String>("fio")
        let _id = Expression<Int>("id")
        
        let all = Array(try db.prepare(users.select(_id)))
        if all.count != 0 {
            try db.run(users.update(name <- pName))
        } else {
            try db.run(users.insert(name <- pName))
        }
        
    } catch {
        print(error)
    }
}

func addDate(pDate: String){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let users = Table("usermac")
        let bdate = Expression<String>("birthday")
        let _id = Expression<Int>("id")
        let all = Array(try db.prepare(users.select(_id)))
        if all.count != 0 {
            try db.run(users.update(bdate <- pDate))
        } else {
            try db.run(users.insert(bdate <- pDate))
        }
    } catch {
        print(error)
    }
}

func addVrach(pVrach: String){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let users = Table("usermac")
        let doc = Expression<String>("doc")
        let _id = Expression<Int>("id")
        let all = Array(try db.prepare(users.select(_id)))
        if all.count != 0 {
            try db.run(users.update(doc <- pVrach))
        } else {
            try db.run(users.insert(doc <- pVrach))
        }
    } catch {
        print(error)
    }
}

func addDateS(pDate: String){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let users = Table("usermac")
        let dateS = Expression<String>("datebegin")
        let _id = Expression<Int>("id")
        let all = Array(try db.prepare(users.select(_id)))
        if all.count != 0 {
            try db.run(users.update(dateS <- pDate))
        } else {
            try db.run(users.insert(dateS <- pDate))
        }
    } catch {
        print(error)
    }
}

func addWeekDay(week: Int, day: Int){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let users = Table("usermac")
        let pweek = Expression<Int>("week")
        let pday = Expression<Int>("day")
        let _id = Expression<Int>("id")
        let all = Array(try db.prepare(users.select(_id)))
        if all.count != 0 {
            try db.run(users.update(pweek <- week, pday <- day))
        } else {
            try db.run(users.insert(pweek <- week, pday <- day))
        }
    } catch {
        print(error)
    }
}

func addID(id: Int){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let users = Table("usermac")
        let _id = Expression<Int>("id")
        let all = Array(try db.prepare(users.select(_id)))
        if all.count != 0 {
            try db.run(users.update(_id <- id))
        } else {
            try db.run(users.insert(_id <- id))
        }
    } catch {
        print(error)
    }
}

func addWeight(Weight: Double){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let users = Table("usermac")
        let weight = Expression<Double>("weight")
        let _id = Expression<Int>("id")
        let all = Array(try db.prepare(users.select(_id)))
        if all.count != 0 {
            try db.run(users.update(weight <- Weight))
        } else {
            try db.run(users.insert(weight <- Weight))
        }
    } catch {
        print(error)
    }
}

func addHeight(Height: Double){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let users = Table("usermac")
        let height = Expression<Double>("height")
        let _id = Expression<Int>("id")
        let all = Array(try db.prepare(users.select(_id)))
        if all.count != 0 {
            try db.run(users.update(height <- Height))
        } else {
            try db.run(users.insert(height <- Height))
        }
    } catch {
        print(error)
    }
}

func addSugarChange(lvl: Double, period: String, physical: Int, time: String){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let sugar = Table("sugarChange")
        let _lvl = Expression<Double>("lvl")
        let _period = Expression<String>("period")
        let _physical = Expression<Int>("physical")
        let _time = Expression<String>("time")
        try db.run(sugar.insert(_lvl <- lvl, _period <- period, _physical <- physical, _time <- time))
    }
    catch {
        print(error)
    }
}

func addAct(min: Int, rod: String, time: String){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let act = Table("act")
        let _min = Expression<Int>("min")
        let _rod = Expression<String>("rod")
        let _time = Expression<String>("time")
        try db.run(act.insert(_min <- min, _rod <- rod, _time <- time))
    }
    catch {
        print(error)
    }
}

func addInject(ed: Double, type: String, priem: String, time: String){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let inject = Table("inject")
        let _ed = Expression<Double>("ed")
        let _type = Expression<String>("type")
        let _priem = Expression<String>("priem")
        let _time = Expression<String>("time")
        try db.run(inject.insert(_ed <- ed, _type <- type, _priem <- priem, _time <- time))
    }
    catch {
        print(error)
    }
}

func addMassa(m: Double, time: String){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let massa = Table("massa")
        let _m = Expression<Double>("m")
        let _time = Expression<String>("time")
        try db.run(massa.insert(_m <- m, _time <- time))
    }
    catch {
        print(error)
    }
}

func addKetonur(mmol: Double, time: String){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let ketonut = Table("ketonur")
        let _mmol = Expression<Double>("mmol")
        let _time = Expression<String>("time")
        try db.run(ketonut.insert(_mmol <- mmol, _time <- time))
    }
    catch{
        print(error)
    }
}

func addDatesToDB(dates: [Date]) {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let fulldays = Table("fulldays")
        let day = Expression<String>("day")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
        for i in 0..<dates.count {
            try db.run(fulldays.insert(day <- dateFormatter.string(from: dates[i])))
        }
    }
    catch {
        print(error)
    }
}

func getDatesFromDB() -> [Date] {
    var dates : [Date] = []
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let fulldays = Table("fulldays")
        let day = Expression<String>("day")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
        for i in try db.prepare(fulldays.select(day)) {
            dates.append(dateFormatter.date(from: i[day])!)
        }
    }
    catch {
        print(error)
    }
    return dates
}

func copyDatabaseIfNeeded(sourcePath: String) -> Bool {
    let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let destinationPath = documents + "/diacompanion.db"
    let exists = FileManager.default.fileExists(atPath: destinationPath)
    guard !exists else { return false }
    do {
        try FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)
        return true
    } catch {
        print("error during file copy: \(error)")
        return false
    }
}
