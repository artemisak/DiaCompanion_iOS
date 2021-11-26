//
//  historyManager.swift
//  dia
//
//  Created by Артем  on 26.11.2021.
//

import Foundation
import SQLite

struct hList: Identifiable, Hashable {
    let name: String
    let id = UUID()
}

class historyList: ObservableObject {
    @Published var histList = [hList]()
    
    func FillHistoryList() async -> Void {
        do {
            var hist = [hList]()
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let diary = Table("diary")
            let d_name = Expression<String>("foodName")
            for i in try db.prepare(diary.select(d_name)){
                hist.append(hList(name: "\(i[d_name])"))
            }
            self.histList = hist
        }
        catch {
            print(error)
        }
    }
    
    func updateDB(element: String) -> Void {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let diary = Table("diary")
            let d_name = Expression<String>("foodName")
            try db.run(diary.filter(d_name == "\(element)").delete())
        }
        catch {
            print(error)
        }
    }
}
