import Foundation
import SQLite
import SwiftUI

enum Route: Hashable {
    case login
    case password
    case version
    case helper
}

class Router: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isChoosed = false
    @Published var version = 1
    @Published var path = [Route]()
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
            let version = Expression<Int>("version")
            let choosed = Expression<Int>("versionChoosed")
            for i in try db.prepare(tb.select(log, version, choosed)){
                self.isLoggedIn = (i[log] != 0)
                self.isChoosed = (i[choosed] != 0)
                self.version = i[version]
            }
        }
        catch {
            print(error)
        }
    }
    
    func navigateToHelper(){
        self.path.append(.helper)
    }
    
    func checkEnteredLogin(_ login: String) -> Bool {
        if login == "almazov" {
            if #available(iOS 16, *){
                self.path.append(.password)
            }
            return true
        } else {
            return false
        }
    }
    
    func checkEnteredPassord(_ password: String) -> Bool {
        if password == "pass123" {
            if #available(iOS 16, *){
                self.path.append(.version)
            }
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
