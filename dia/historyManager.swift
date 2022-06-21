import Foundation
import SQLite

struct hList: Identifiable, Hashable {
    var type: Int
    var name: String
    var date: String
    var bdID: [Int]
    var metaInfo: [[String]]
    let id = UUID()
}

class historyList: ObservableObject {
    @Published var histList = [hList]()
    
    @MainActor
    func FillHistoryList() async -> Void {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            
            // MARK: Заполняем еду
            let diary = Table("diary")
            let dateTime = Expression<String>("dateTime")
            let foodType = Expression<String>("foodType")
            let id = Expression<Int>("id")
            let gram = Expression<String>("g")
            let fName = Expression<String>("foodName")
            let foodInfo = Table("food")
            let prot = Expression<Double>("prot")
            let fat = Expression<Double>("fat")
            let carbo = Expression<Double>("carbo")
            let kkal = Expression<Double>("ec")
            let gi = Expression<Double>("gi")
            let name = Expression<String>("name")
            
            var temp: [String] = []
            for i in try db.prepare(diary.select(foodType, dateTime)){
                temp.append(i[foodType]+"/"+i[dateTime])
            }
            
            let uniqueValue = Array(Set(temp))
            for i in uniqueValue {
                let spl = i.components(separatedBy: "/")
                histList.append(hList(type: 0, name: spl[0], date: spl[1], bdID: [], metaInfo: []))
            }
            
            for i in 0...histList.count-1 {
                if histList[i].type == 0 {
                    for i1 in try db.prepare(diary.select(id, gram, fName).filter(dateTime == histList[i].date && foodType == histList[i].name)){
                        histList[i].bdID.append(i1[id])
                        histList[i].metaInfo.append([i1[fName], i1[gram]])
                    }
                    for i2 in 0...histList[i].metaInfo.count-1 {
                        for i3 in try db.prepare(foodInfo.select(prot,fat,carbo,kkal,gi).filter(name == histList[i].metaInfo[i2][0])){
                            histList[i].metaInfo[i2].append(contentsOf: [String(i3[prot]), String(i3[fat]), String(i3[carbo]), String(i3[kkal]), String(i3[gi])])
                        }
                    }
                    histList[i].name = histList[i].name + " (\(histList[i].bdID.count) сост.)"
                }
            }
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
