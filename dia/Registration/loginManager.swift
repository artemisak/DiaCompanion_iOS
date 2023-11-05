import Foundation
import SQLite

class Router: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isChoosed = false
    @Published var version = 1
    @Published var animateTransition = false
    @Published var tabViewStatment: Int = 1
    
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
    
    func authorization(login: String, password: String, complition: @escaping (Bool) -> Void) async {

        var request = URLRequest(url: URL(string: "https://diacompanion.ru/login")!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let parameters = [
            "username": login,
            "password": password
        ]

        let postData = parameters.map { (key, value) in
            return "\(key)=\(value)"
        }.joined(separator: "&")

        let postDataEncoded = postData.data(using: .utf8)

        request.httpBody = postDataEncoded

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            if httpResponse.statusCode == 200 {
                complition(true)
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let detail = json?["detail"] as? String {
                            print(detail)
                        }
                    } catch {
                        print(error)
                    }
                }
            } else if httpResponse.statusCode == 400 {
                complition(false)
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let detail = json?["detail"] as? String {
                            print(detail)
                        }
                    } catch {
                        print(error)
                    }
                }
            } else if httpResponse.statusCode == 403 {
                complition(false)
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let detail = json?["detail"] as? String {
                            print(detail)
                        }
                    } catch {
                        print(error)
                    }
                }
            } else if httpResponse.statusCode == 503 {
                complition(false)
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let detail = json?["detail"] as? String {
                            print(detail)
                        }
                    } catch {
                        print(error)
                    }
                }
            } else {
                complition(false)
            }
        }
        
        task.resume()

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
    func setChoosed() async {
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
                try db.run(tb.update(version <- self.version))
                self.isChoosed = true
            }
            catch {
                print(error)
            }
        }
    }
}
