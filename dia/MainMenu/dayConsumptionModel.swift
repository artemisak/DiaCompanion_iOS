//
//  dayConsumptionModel.swift
//  dia
//
//  Created by Артём Исаков on 27.01.2023.
//

import Foundation
import SQLite3

struct nutrients: Identifiable, Hashable {
    var id = UUID()
    var prot: Double
    var fat: Double
    var carbo: Double
    var kkal: Double
}

enum sunStatment: String {
    case sunMax = "sun.max"
    case sunrise = "sunrise"
    case sunset = "sunset"
    case moon = "moon.zzz"
}

class dayConsumptionModel : ObservableObject {
    @Published var prot: Double
    @Published var fat: Double
    @Published var carbo: Double
    @Published var kkal: Double
    @Published var sunImage: sunStatment
    
    @MainActor
    func setUpVidget() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let nutr = await retriveNutrients(date: dateFormatter.string(from: Date())) ?? [0.0, 0.0, 0.0, 0.0]
        prot = nutr[0]
        fat = nutr[1]
        carbo = nutr[2]
        kkal = nutr[3]
        sunImage = await retriveImage() ?? .sunMax
    }
    
    func retriveImage() async -> sunStatment? {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let now = timeFormatter.date(from: timeFormatter.string(from: Date()))!
        if (now >= timeFormatter.date(from: "21:00")!) || (now <= timeFormatter.date(from: "05:00")!) {
            return .moon
        }
        else if (now > timeFormatter.date(from: "05:00")!) && (now < timeFormatter.date(from: "11:00")!) {
            return .sunrise
        }
        else if (now > timeFormatter.date(from: "11:00")!) && (now < timeFormatter.date(from: "17:00")!) {
            return .sunMax
        }
        else if (now > timeFormatter.date(from: "17:00")!) && (now < timeFormatter.date(from: "21:00")!) {
            return .sunset
        } else {
            return nil
        }
    }
    
    func retriveNutrients(date: String) async -> [Double]? {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)

        var db: OpaquePointer?
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("Error opening database")
            sqlite3_close(db)
            db = nil
            return nil
        }

        var statement: OpaquePointer?
        
        let sql = "SELECT sum(prot*g/100), sum(fat*g/100), sum(carbo*g/100), sum(ec*g/100) FROM food INNER JOIN (SELECT id_food, g FROM diary WHERE date = '\(date)') as tb1 ON food._id = tb1.id_food"

        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
        }

        var prt = 0.0
        var ft = 0.0
        var crb = 0.0
        var kkl = 0.0
        
        while sqlite3_step(statement) == SQLITE_ROW {
            if sqlite3_column_type(statement, 0) == 2 {
                prt = sqlite3_column_double(statement, 0)
            }
            if sqlite3_column_type(statement, 1) == 2 {
                ft = sqlite3_column_double(statement, 1)
            }
            if sqlite3_column_type(statement, 2) == 2 {
                crb = sqlite3_column_double(statement, 2)
            }
            if sqlite3_column_type(statement, 3) == 2 {
                kkl = sqlite3_column_double(statement, 3)
            }
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
        
        return [prt, ft, crb, kkl]
    }
    
    init() {
        self.prot = 0.0
        self.fat = 0.0
        self.carbo = 0.0
        self .kkal = 0.0
        self.sunImage = .sunMax
    }
}
