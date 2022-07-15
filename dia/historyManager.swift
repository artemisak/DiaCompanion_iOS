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
            
            if !histList.isEmpty {
                for i in 0...histList.count-1 {
                    for i1 in try db.prepare(diary.select(id, gram, fName).filter(dateTime == histList[i].date && foodType == histList[i].name)){
                        histList[i].bdID.append(i1[id])
                        let temp = try db.prepare(foodInfo.select(prot,fat,carbo,kkal,gi).filter(name == i1[fName]))
                        _ = temp.map{histList[i].metaInfo.append([i1[fName], i1[gram], String($0[prot]), String($0[fat]), String($0[carbo]), String($0[kkal]), String($0[gi])])}
                    }
                    histList[i].name = histList[i].name + " (\(histList[i].bdID.count) сост.)"
                }
            }
            
            // MARK: Заолняем физическую активность
            let activity = Table("act")
            let actId = Expression<Int>("id")
            let rodz = Expression<String>("rod")
            let min = Expression<Int>("min")
            let timeAct = Expression<String>("time")
            
            for i in try db.prepare(activity.select(actId, rodz, min, timeAct)) {
                histList.append(hList(type: 1, name: "\(i[rodz]), \(i[min]) мин.", date:  i[timeAct], bdID: [i[actId]], metaInfo: [[i[rodz],String(i[min])]]))
            }
            
            // MARK: Заполняем прием инсулина
            let insulinInject = Table("inject")
            let injectId = Expression<Int>("id")
            let ed = Expression<Double>("ed")
            let type = Expression<String>("type")
            let priem = Expression<String>("priem")
            let timeInject = Expression<String>("time")
            
            for i in try db.prepare(insulinInject.select(injectId, ed, type, priem, timeInject)){
                histList.append(hList(type: 2, name: "\(i[ed]) Ед. (\(i[priem]))", date: i[timeInject], bdID: [i[id]], metaInfo: [[String(i[ed]), i[priem], i[type]]]))
            }
            
            // MARK: Заполняем измерение сахара
            let sugar = Table("sugarChange")
            let sugarId = Expression<Int>("id")
            let sugarLvL = Expression<Double>("lvl")
            let sugarPeriod = Expression<String>("period")
            let sugarPhysical = Expression<Int>("physical")
            let sugarTime = Expression<String>("time")
            
            for i in try db.prepare(sugar.select(sugarId, sugarLvL, sugarPeriod, sugarPhysical, sugarTime)) {
                histList.append(hList(type: 3, name: "\(i[sugarLvL]) м/л (\(i[sugarPeriod]))", date: i[sugarTime], bdID: [i[sugarId]], metaInfo: [[String(i[sugarLvL]), i[sugarPeriod], String(i[sugarPhysical])]]))
            }
            
            // MARK: Заполняем кетоны
            let keton = Table("ketonur")
            let ketonId = Expression<Int>("id")
            let ketonMmol = Expression<Double>("mmol")
            let ketonTime = Expression<String>("time")
            
            for i in try db.prepare(keton.select(id,ketonMmol,ketonTime)) {
                histList.append(hList(type: 4, name: "Кетоны: \(i[ketonMmol]) ммоль/л", date: i[ketonTime], bdID: [i[ketonId]], metaInfo: [[String(i[ketonMmol])]]))
            }
            
            // MARK: Заполняем измерение массы
            let massa = Table("massa")
            let massaId = Expression<Int>("id")
            let m = Expression<Double>("m")
            let massaTime = Expression<String>("time")
            
            for i in try db.prepare(massa.select(massaId, m, massaTime)){
                histList.append(hList(type: 5, name: "Вес: \(i[m]) кг", date: i[massaTime], bdID: [i[massaId]], metaInfo: [[String(i[m])]]))
            }
            
            // MARK: Сортируем от большего к меньшему по дате
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
            histList.sort(by: {dateFormatter.date(from: $1.date)! < dateFormatter.date(from: $0.date)!})
        }
        catch {
            print(error)
        }
    }
}

func deleteFromBD(idToDelete: [Int], table: Int) {
    do {
        var t = ""
        if table == 0 {
            t = "diary"
        }
        else if table == 1 {
            t = "act"
        }
        else if table == 2 {
            t = "inject"
        }
        else if table == 3 {
            t = "sugarChange"
        }
        else if table == 4 {
            t = "ketonur"
        }
        else if table == 5 {
            t = "massa"
        }
        
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let diary = Table(t)
        let id = Expression<Int>("id")
        for i in 0...idToDelete.count-1 {
            try db.run(diary.filter(id == idToDelete[i]).delete())
        }
    }
    catch {
        print(error)
    }
}

func deleteAndSave(idToDelete: [Int], table: Int, info: [Any]) {
    do {
        var t = ""
        var type = ""
        if table == 0 {
            t = "diary"
            type = "Приемы пищи"
        }
        else if table == 1 {
            t = "act"
            type = "Физическая нагрузка и сон"
        }
        else if table == 2 {
            t = "inject"
            type = "Введение инсулина"
        }
        else if table == 3 {
            t = "sugarChange"
            type = "Измерение сахара"
        }
        else if table == 4 {
            t = "ketonur"
            type = "Кетоны в моче"
        }
        else if table == 5 {
            t = "massa"
            type = "Измерение массы тела"
        }
        
        let day = (info[0] as? String)![6..<16]
        let time = (info[0] as? String)![0..<6]
        let name = (info[1] as? String)!
        
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let diary = Table(t)
        let id = Expression<Int>("id")
        for i in 0...idToDelete.count-1 {
            try db.run(diary.filter(id == idToDelete[i]).delete())
        }
        
        let deleted = Table("deleted")
        let ddate = Expression<String>("date")
        let dtime = Expression<String>("time")
        let dtype = Expression<String>("type")
        let dcontext = Expression<String>("context")
        try db.run(deleted.insert(ddate <- day, dtime <- time, dtype <- type, dcontext <- name))
    }
    catch {
        print(error)
    }
}
