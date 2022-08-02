//
//  File.swift
//  dia
//
//  Created by Артём Исаков on 30.07.2022.
//

import Foundation
import SQLite

struct fruit: Identifiable, Hashable {
    var name: String
    var range: Int
    var id = UUID()
}

class fruits : ObservableObject {
    @Published var apples = [fruit]()
    func fillBasket() -> Void {
        apples.append(fruit(name: "Red apples", range: 1))
        apples.append(fruit(name: "Green apples", range: 1))
        apples.append(fruit(name: "Golden apples", range: 1))
        apples.append(fruit(name: "Summer apples", range: 1))
        apples.append(fruit(name: "Red royal apples", range: 1))
    }
    func searchFromDB(_ str: String, _ off: Int) {
        do {
            if off == 0 {
                apples.removeAll()
            }
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let foods = Table("food")
            let name = Expression<String>("name")
            for i in try db.prepare(foods.select(name).filter(name.like("%\(str)%")).order(name).limit(15,offset: off)){
                apples.append(fruit(name: i[name], range: 1))
            }
        }
        catch {
            print(error)
        }
    }
}
