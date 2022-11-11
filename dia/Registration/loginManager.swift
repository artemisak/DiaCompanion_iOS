import Foundation
import SQLite

class check: ObservableObject {
    
    @Published var istrue = false
    @Published var isChoosed = false
    @Published var version = 1
    
    func checklog() {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let tb = Table("usermac")
            let log = Expression<Int>("loggedin")
            let version = Expression<Int>("version")
            let choosed = Expression<Int>("versionChoosed")
            for i in try db.prepare(tb.select(log, version, choosed)){
                self.istrue = (i[log] != 0)
                self.isChoosed = (i[choosed] != 0)
                self.version = i[version]
            }
        }
        catch {
            print(error)
        }
    }
    
    func setlogged(upass: String, ulogin: String) -> Bool {
        if (upass == "pass123") && (ulogin == "almazov") {
            do {
                let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let path = documents + "/diacompanion.db"
                let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
                _=copyDatabaseIfNeeded(sourcePath: sourcePath)
                let db = try Connection(path)
                let tb = Table("usermac")
                let log = Expression<Int>("loggedin")
                try db.run(tb.update(log <- 1))
                self.istrue = true
            }
            catch {
                print(error)
            }
            return true
        } else {
            self.istrue = false
            return false
        }
    }
    
    func setChoosed(v: Int) {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let tb = Table("usermac")
            let choosed = Expression<Int>("versionChoosed")
            let version = Expression<Int>("version")
            try db.run(tb.update(choosed <- 1))
            try db.run(tb.update(version <- v))
            self.version = v
            self.isChoosed = true
        }
        catch {
            print(error)
        }
    }
}
