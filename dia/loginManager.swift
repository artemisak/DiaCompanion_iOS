//
//  checkLogin.swift
//  dia
//
//  Created by Артём Исаков on 13.02.2022.
//

import Foundation
import SQLite

class check: ObservableObject {
    @Published var login = false
    @Published var istrue = false
    func checklog() async -> Void {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let tb = Table("usermac")
            let log = Expression<Int64>("loggedin")
            for i in try db.prepare(tb.select(log)){
                self.login = (i[log] != 0)
                self.istrue = self.login
            }
        }
        catch {
            print(error)
        }
    }
    func setlogged(upass: String, ulogin: String) async -> Void {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let tb = Table("usermac")
            let log = Expression<Int64>("loggedin")
            if (upass == "pass123") && (ulogin == "almazov") {
                try db.run(tb.update(log <- 1))
                self.istrue = true
            }
        }
        catch {
            print(error)
        }
    }
}


