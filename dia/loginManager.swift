import Foundation
import SQLite

class check: ObservableObject {
    
    @Published var istrue = false
    
    func checklog() -> Void {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let tb = Table("usermac")
            let log = Expression<Int64>("loggedin")
            for i in try db.prepare(tb.select(log)){
                self.istrue = (i[log] != 0)
            }
        }
        catch {
            print(error)
        }
    }
    
    func setlogged(upass: String, ulogin: String) -> Bool {
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
                return true
            } else {
                return false
            }
        }
        catch {
            print(error)
            return false
        }
    }
}
