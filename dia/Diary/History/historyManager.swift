import Foundation
import SQLite

struct hList: Identifiable, Hashable {
    var type: Int
    var name: [String]
    var date: String
    var bdID: [Int]
    var tbID: [Int]
    var metaInfo: [[String]]
    let id = UUID()
}

class historyList: ObservableObject {
    @Published var histList = [hList]()
    @Published var fillterList = [hList]()
    
    func FillHistoryList() -> Void {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            
            // MARK: Заполняем еду
            let diary = Table("diary")
            let id = Expression<Int>("id")
            let table_id_key = Expression<Int>("id_food")
            let dateTime = Expression<String>("dateTime")
            let foodType = Expression<String>("foodType")
            let fName = Expression<String>("foodName")
            let gram = Expression<String>("g")
            
            let foodInfo = Table("food")
            let food_id = Expression<Int>("_id")
            let prot = Expression<Double>("prot")
            let fat = Expression<Double>("fat")
            let carbo = Expression<Double>("carbo")
            let kkal = Expression<Double>("ec")
            let gi = Expression<Double>("gi")
            let name = Expression<String>("name")
            
            let sugarR = Table("predicted")
            let sdate = Expression<String>("date")
            let stime = Expression<String>("time")
            let BG0 = Expression<Double>("BG0")
            let BG1 = Expression<Double>("BG1")
            
            var temp: [String] = []
            for i in try db.prepare(diary.select(foodType, dateTime)){
                temp.append(i[foodType]+"/"+i[dateTime])
            }
            let uniqueValue = Array(Set(temp))
            
            for i in uniqueValue {
                let spl = i.components(separatedBy: "/")
                histList.append(hList(type: 0, name: [spl[0]], date: spl[1], bdID: [], tbID: [], metaInfo: []))
            }
            if !histList.isEmpty {
                for i in 0...histList.count-1 {
                    var temp0 = -0.1
                    var temp1 = -0.1
                    for i2 in try db.prepare(sugarR.select(BG0,BG1).filter(sdate == histList[i].date[6..<16] && stime == histList[i].date[0..<5])){
                        temp0 = i2[BG0]
                        temp1 = round(i2[BG1]*10000)/100
                    }
                    for i1 in try db.prepare(diary.select(id, table_id_key, gram, fName).filter(dateTime == histList[i].date && foodType == histList[i].name[0])){
                        histList[i].bdID.append(i1[id])
                        histList[i].tbID.append(i1[table_id_key])
                        let gramm = Double(i1[gram]) ?? 100.0
                        let temp = try db.prepare(foodInfo.select(prot,fat,carbo,kkal,gi).filter(name == i1[fName] && food_id == i1[table_id_key]))
                        _ = temp.map{histList[i].metaInfo.append([i1[fName], i1[gram], "\(round($0[prot]*(gramm/100)*100)/100)", "\(round($0[fat]*(gramm/100)*100)/100)", "\(round($0[carbo]*(gramm/100)*100)/100)", "\(round($0[kkal]*(gramm/100)*100)/100)", "\($0[gi])", "\(round(($0[carbo]*(gramm/100)/100*$0[gi])*100)/100)", "\(temp0)", "\(temp1)"])}
                    }
                    histList[i].name = ["\(histList[i].name[0])", "\(histList[i].bdID.count)"]
                }
            }
            
            // MARK: Заолняем физическую активность
            let activity = Table("act")
            let actId = Expression<Int>("id")
            let rodz = Expression<String>("rod")
            let min = Expression<Int>("min")
            let timeAct = Expression<String>("time")
            
            for i in try db.prepare(activity.select(actId, rodz, min, timeAct)) {
                if i[rodz] != "Сон" {
                    histList.append(hList(type: 1, name: ["\(i[rodz])", "\(i[min])"], date:  i[timeAct], bdID: [i[actId]], tbID: [], metaInfo: [[i[rodz],String(i[min])]]))
                } else {
                    histList.append(hList(type: 1, name: ["\(i[rodz])", "\(i[min])"], date:  i[timeAct], bdID: [i[actId]], tbID: [], metaInfo: [[i[rodz],String(i[min])]]))
                }
            }
            
            // MARK: Заполняем прием инсулина
            let insulinInject = Table("inject")
            let injectId = Expression<Int>("id")
            let ed = Expression<Double>("ed")
            let type = Expression<String>("type")
            let priem = Expression<String>("priem")
            let timeInject = Expression<String>("time")
            
            for i in try db.prepare(insulinInject.select(injectId, ed, type, priem, timeInject)){
                histList.append(hList(type: 2, name: ["\(i[ed])", "\(i[priem])"], date: i[timeInject], bdID: [i[id]], tbID: [], metaInfo: [[String(i[ed]), i[priem], i[type]]]))
            }
            
            // MARK: Заполняем измерение сахара
            let sugar = Table("sugarChange")
            let sugarId = Expression<Int>("id")
            let sugarLvL = Expression<Double>("lvl")
            let sugarPeriod = Expression<String>("period")
            let sugarPhysical = Expression<Int>("physical")
            let sugarTime = Expression<String>("time")
            
            for i in try db.prepare(sugar.select(sugarId, sugarLvL, sugarPeriod, sugarPhysical, sugarTime)) {
                histList.append(hList(type: 3, name: ["\(i[sugarLvL])", "\(i[sugarPeriod])"], date: i[sugarTime], bdID: [i[sugarId]], tbID: [], metaInfo: [[String(i[sugarLvL]), i[sugarPeriod], String(i[sugarPhysical])]]))
            }
            
            // MARK: Заполняем кетоны
            let keton = Table("ketonur")
            let ketonId = Expression<Int>("id")
            let ketonMmol = Expression<Double>("mmol")
            let ketonTime = Expression<String>("time")
            
            for i in try db.prepare(keton.select(id,ketonMmol,ketonTime)) {
                histList.append(hList(type: 4, name: ["\(i[ketonMmol])"], date: i[ketonTime], bdID: [i[ketonId]], tbID: [], metaInfo: [[String(i[ketonMmol])]]))
            }
            
            // MARK: Заполняем измерение массы
            let massa = Table("massa")
            let massaId = Expression<Int>("id")
            let m = Expression<Double>("m")
            let massaTime = Expression<String>("time")
            
            for i in try db.prepare(massa.select(massaId, m, massaTime)){
                histList.append(hList(type: 5, name: ["\(i[m])"], date: i[massaTime], bdID: [i[massaId]], tbID: [], metaInfo: [[String(i[m])]]))
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
    
    func refillHistoryList() -> Void {
        histList = []
        FillHistoryList()
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

func deleteCorespondingRecords(date: Date){
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let predicted = Table("predicted")
        let date_field = Expression<String>("date")
        let time_field = Expression<String>("time")
        let df_date = DateFormatter()
        df_date.dateFormat = "dd.MM.yyy"
        let df_time = DateFormatter()
        df_time.dateFormat = "HH:mm"
        try db.run(predicted.filter(date_field == df_date.string(from: date) && time_field == df_time.string(from: date)).delete())
    } catch {
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
            type = "Измерение глюкозы"
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

extension hList {
    func getDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm dd.MM.yyyy"
        return df.date(from: self.date)!.formatted(date: .numeric, time: .omitted)
    }
}
