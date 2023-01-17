import Foundation
import SQLite

class Router: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isChoosed = false
    @Published var version = 1
    @Published var animateTransition = false
    
    func checkIfLogged() {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let tb = Table("usermac")
            let log = Expression<Int>("loggedin")
            let v = Expression<Int>("version")
            let choosed = Expression<Int>("versionChoosed")
            for i in try db.prepare(tb.select(log, v, choosed)){
                isLoggedIn = (i[log] != 0)
                isChoosed = (i[choosed] != 0)
                version = i[v]
            }
        }
        catch {
            print(error)
        }
    }
        
    func checkEnteredLogin(_ login: String) -> Bool {
        if login == "almazov" {
            return true
        } else {
            return false
        }
    }
    
    func checkEnteredPassord(_ password: String) -> Bool {
        if password == "pass123" {
            return true
        } else {
            return false
        }
    }
    
    @MainActor
    func setLogged() async {
        Task {
            do {
                let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let path = documents + "/diacompanion.db"
                let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
                _=copyDatabaseIfNeeded(sourcePath: sourcePath)
                let db = try Connection(path)
                let tb = Table("usermac")
                let log = Expression<Int>("loggedin")
                try db.run(tb.update(log <- 1))
                self.isLoggedIn = true
            }
            catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func setChoosed(number: Int) async {
        Task {
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
                try db.run(tb.update(version <- number))
                self.version = number
                self.isChoosed = true
                self.animateTransition = true
            }
            catch {
                print(error)
            }
        }
    }
}
