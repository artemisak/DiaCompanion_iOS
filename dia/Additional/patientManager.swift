import Foundation
import SQLite

enum inputErorrs: Error {
    case decimalError
    case EmptyError
    case SymbolicError
    case UndefinedError
}

enum doc: String, CaseIterable, Identifiable {
    case Anopova = "Анопова А.Д."
    case Bolotko = "Болотько Я.А."
    case Dronova = "Дронова А.В."
    case Popova = "Попова П.В."
    case Tkachuk = "Ткачут А.С."
    case Vasukova = "Васюкова Е.А."
    case Pashkova = "Пашкова К.В."
    case without = "Без врача"
    var id: Self { self }
}

struct Person {
    var id = UUID()
    var fio: String
    var birthday: Date
    var selectedDoc: doc
    var start_date: Date
    var week_of_start: Int
    var day_of_start: Int
    var patientID: Int
    var weight: Double
    var height: Double
}

class patientViewModel: ObservableObject {
    @Published var woman: Person
    
    init() {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let users = Table("usermac")
            let id = Expression<Int?>("id")
            let name = Expression<String?>("fio")
            let birthday = Expression<String?>("birthday")
            let start_date = Expression<String?>("datebegin")
            let week = Expression<Int?>("week")
            let day = Expression<Int?>("day")
            let weight = Expression<Double?>("weight")
            let height = Expression<Double?>("height")
            let doctor = Expression<String?>("doc")
            
            var patient_id = 1
            var patient_name = ""
            var patient_birthday = Date().addingTimeInterval(-60*60*24*365*25)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            var patient_start_date = Date()
            var patient_week = 22
            var patient_day = 3
            var patient_weight = 0.0
            var patient_height = 0.0
            var patient_doc = "Без врача"
            for i in try db.prepare(users.select(id, name, birthday, week, day, weight, height, doctor, start_date)) {
                if i[id] != nil && i[name] != nil && i[birthday] != nil && i[week] != nil  && i[day] != nil  && i[weight] != nil  && i[height] != nil && i[doctor] != nil && i[start_date] != nil {
                    patient_id = i[id]!
                    patient_name = i[name]!
                    patient_birthday = formatter.date(from: i[birthday]!)!
                    patient_start_date = formatter.date(from: i[start_date]!)!
                    patient_week = i[week]!
                    patient_day = i[day]!
                    patient_weight = i[weight]!
                    patient_height = i[height]!
                    patient_doc = i[doctor]!
                }
            }
            self.woman = Person(fio: patient_name, birthday: patient_birthday, selectedDoc: doc(rawValue: patient_doc)!, start_date: patient_start_date, week_of_start: patient_week, day_of_start: patient_day, patientID: patient_id, weight: patient_weight, height: patient_height)
            
        } catch {
            print(error)
            self.woman = Person(fio: "Без указания", birthday: Date().addingTimeInterval(-60*60*24*365*23), selectedDoc: .without, start_date: Date(), week_of_start: 22, day_of_start: 3,  patientID: 1, weight: 60.0, height: 175.0)
        }
    }
}

class patientManager {
    
    static let provider = patientManager()
    
    func savePatientCart(name: String, birthDay: Date, doc: String, start_day: Date, week: Int, day: Int, id: Int, height: Double, weight: Double) async {
        Task {
            addName(pName: name)
            addBirthDate(pDate: birthDay)
            addDoc(pDoc: doc)
            addWeekDay(pWeek: week, pDay: day)
            addStartDate(pStartDate: start_day)
            addID(pID: id)
            addWeight(pWeight: weight)
            addHeight(pHeight: height)
        }
    }
    
    func addName(pName: String){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let users = Table("usermac")
            let name = Expression<String>("fio")
            let _id = Expression<Int>("id")
            
            let all = Array(try db.prepare(users.select(_id)))
            if all.count != 0 {
                try db.run(users.update(name <- pName))
            } else {
                try db.run(users.insert(name <- pName))
            }
            
        } catch {
            print(error)
        }
    }
    
    func addBirthDate(pDate: Date){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let users = Table("usermac")
            let bdate = Expression<String>("birthday")
            let _id = Expression<Int>("id")
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let all = Array(try db.prepare(users.select(_id)))
            if all.count != 0 {
                try db.run(users.update(bdate <- formatter.string(from: pDate)))
            } else {
                try db.run(users.insert(bdate <- formatter.string(from: pDate)))
            }
        } catch {
            print(error)
        }
    }
    
    func addDoc(pDoc: String){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let users = Table("usermac")
            let doc = Expression<String>("doc")
            let id = Expression<Int>("id")
            let all = Array(try db.prepare(users.select(id)))
            if all.count != 0 {
                try db.run(users.update(doc <- pDoc))
            } else {
                try db.run(users.insert(doc <- pDoc))
            }
        } catch {
            print(error)
        }
    }
    
    func addStartDate(pStartDate: Date){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let users = Table("usermac")
            let startDate = Expression<String>("datebegin")
            let id = Expression<Int>("id")
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let all = Array(try db.prepare(users.select(id)))
            if all.count != 0 {
                try db.run(users.update(startDate <- formatter.string(from: pStartDate)))
            } else {
                try db.run(users.insert(startDate <- formatter.string(from: pStartDate)))
            }
        } catch {
            print(error)
        }
    }
    
    func addWeekDay(pWeek: Int, pDay: Int){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let users = Table("usermac")
            let week = Expression<Int>("week")
            let day = Expression<Int>("day")
            let id = Expression<Int>("id")
            let all = Array(try db.prepare(users.select(id)))
            if all.count != 0 {
                try db.run(users.update(week <- pWeek, day <- pDay))
            } else {
                try db.run(users.insert(week <- pWeek, day <- pDay))
            }
        } catch {
            print(error)
        }
    }
    
    func addID(pID: Int){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let users = Table("usermac")
            let id = Expression<Int>("id")
            let all = Array(try db.prepare(users.select(id)))
            if all.count != 0 {
                try db.run(users.update(id <- pID))
            } else {
                try db.run(users.insert(id <- pID))
            }
        } catch {
            print(error)
        }
    }
    
    func addWeight(pWeight: Double){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let users = Table("usermac")
            let weight = Expression<Double>("weight")
            let id = Expression<Int>("id")
            let all = Array(try db.prepare(users.select(id)))
            if all.count != 0 {
                try db.run(users.update(weight <- pWeight))
            } else {
                try db.run(users.insert(weight <- pWeight))
            }
        } catch {
            print(error)
        }
    }
    
    func addHeight(pHeight: Double){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let users = Table("usermac")
            let height = Expression<Double>("height")
            let id = Expression<Int>("id")
            let all = Array(try db.prepare(users.select(id)))
            if all.count != 0 {
                try db.run(users.update(height <- pHeight))
            } else {
                try db.run(users.insert(height <- pHeight))
            }
        } catch {
            print(error)
        }
    }
    
    func addSugarChange(lvl: Double, period: String, physical: Int, time: String){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let sugar = Table("sugarChange")
            let _lvl = Expression<Double>("lvl")
            let _period = Expression<String>("period")
            let _physical = Expression<Int>("physical")
            let _time = Expression<String>("time")
            try db.run(sugar.insert(_lvl <- lvl, _period <- period, _physical <- physical, _time <- time))
        }
        catch {
            print(error)
        }
    }
    
    func addAct(min: Int, rod: String, time: String){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let act = Table("act")
            let _min = Expression<Int>("min")
            let _rod = Expression<String>("rod")
            let _time = Expression<String>("time")
            try db.run(act.insert(_min <- min, _rod <- rod, _time <- time))
        }
        catch {
            print(error)
        }
    }
    
    func addInject(ed: Double, type: String, priem: String, time: String){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let inject = Table("inject")
            let _ed = Expression<Double>("ed")
            let _type = Expression<String>("type")
            let _priem = Expression<String>("priem")
            let _time = Expression<String>("time")
            try db.run(inject.insert(_ed <- ed, _type <- type, _priem <- priem, _time <- time))
        }
        catch {
            print(error)
        }
    }
    
    func addMassa(m: Double, time: String){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let massa = Table("massa")
            let _m = Expression<Double>("m")
            let _time = Expression<String>("time")
            try db.run(massa.insert(_m <- m, _time <- time))
        }
        catch {
            print(error)
        }
    }
    
    func addKetonur(mmol: Double, time: String){
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let ketonut = Table("ketonur")
            let _mmol = Expression<Double>("mmol")
            let _time = Expression<String>("time")
            try db.run(ketonut.insert(_mmol <- mmol, _time <- time))
        }
        catch{
            print(error)
        }
    }
    
    func addDatesToDB(dates: [Date]) {
        var exist_dates : [Date] = []
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let fulldays = Table("fulldays")
            let day = Expression<String>("day")
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
            
            for i in try db.prepare(fulldays.select(day)){
                exist_dates.append(dateFormatter.date(from: i[day])!)
            }
            
            for i in 0..<dates.count {
                if  !exist_dates.contains(dates[i]) {
                    try db.run(fulldays.insert(day <- dateFormatter.string(from: dates[i])))
                }
            }
            
            for i in 0..<exist_dates.count {
                if  !dates.contains(exist_dates[i]) {
                    try db.run(fulldays.filter(day == dateFormatter.string(from:exist_dates[i])).delete())
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    func getDatesFromDB() -> [Date] {
        var dates : [Date] = []
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let fulldays = Table("fulldays")
            let day = Expression<String>("day")
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
            for i in try db.prepare(fulldays.select(day)) {
                dates.append(dateFormatter.date(from: i[day])!)
            }
        }
        catch {
            print(error)
        }
        return dates
    }
    
    func checkName(txt: String) throws -> String {
        guard !txt.isEmpty else {
            throw inputErorrs.EmptyError
        }
        guard !txt.contains(where: {$0 == "." || $0 == "," || $0 == "?" || $0 == "/" || $0 == "$" || $0 == "%" || $0 == ":" || $0 == "!" || $0 == "@" || $0 == "#" || $0 == "^" || $0 == "&" || $0 == "*" || $0 == ";"}) else {
            throw inputErorrs.SymbolicError
        }
        return txt
    }
    
    func checkBMI() -> Bool {
        var res: Bool = false
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let patient = Table("usermac")
            let w = Expression<Double?>("weight")
            let h = Expression<Double?>("height")
            for i in try db.prepare(patient.select(w,h)){
                if (i[w] != nil && i[h] != nil) {
                    res = true
                }
            }
        }
        catch {
            print(error)
        }
        return res
    }
    
    func deleteAccaunt() async -> Void {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let act = Table("act")
            try db.run(act.delete())
            let deleted = Table("deleted")
            try db.run(deleted.delete())
            let diary = Table("diary")
            try db.run(diary.delete())
            let fulldays = Table("fulldays")
            try db.run(fulldays.delete())
            let inject = Table("inject")
            try db.run(inject.delete())
            let ketonur = Table("ketonur")
            try db.run(ketonur.delete())
            let massa = Table("massa")
            try db.run(massa.delete())
            let predicted = Table("predicted")
            try db.run(predicted.delete())
            let sugarChange = Table("sugarChange")
            try db.run(sugarChange.delete())
            let usermac = Table("usermac")
            let id = Expression<Int>("id")
            let loggedin = Expression<Int>("loggedin")
            let vesrionChoosed = Expression<Int>("versionChoosed")
            let version = Expression<Int>("version")
            try db.run(usermac.delete())
            try db.run(usermac.insert(id <- 1, loggedin <- 0, vesrionChoosed <- 0, version <- 1))
        }
        catch {
            print(error)
        }
    }
    
    func getPreloadFIO() -> String {
        do {
            var txt = ""
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let macUser = Table("usermac")
            let fio = Expression<String?>("fio")
            for i in try db.prepare(macUser.select(fio)){
                txt = i[fio] ?? "Новый пользователь"
            }
            return txt
        }
        catch {
            print(error)
            return "Новый пользователь"
        }
    }
    
    func getPreloadID() -> String {
        do {
            var txt = "1"
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let macUser = Table("usermac")
            let id = Expression<Int>("id")
            for i in try db.prepare(macUser.select(id)){
                txt = "\(i[id])"
            }
            return txt
        }
        catch {
            print(error)
            return "1"
        }
    }
    
    func getPreloadWeight() -> String {
        do {
            var txt = ""
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let macUser = Table("usermac")
            let w = Expression<Double?>("weight")
            for i in try db.prepare(macUser.select(w)){
                if i[w] != nil {
                    txt = "\(i[w]!)".replacingOccurrences(of: ".", with: ",")
                }
            }
            return txt
        }
        catch {
            print(error)
            return ""
        }
    }
    
    func getPreloadHeight() -> String {
        do {
            var txt = ""
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let macUser = Table("usermac")
            let h = Expression<Double?>("height")
            for i in try db.prepare(macUser.select(h)){
                if i[h] != nil {
                    txt = "\(i[h]!)".replacingOccurrences(of: ".", with: ",")
                }
            }
            return txt
        }
        catch {
            print(error)
            return ""
        }
    }
    
    func getPreloadBD() -> Date {
        do {
            var txt: String = ""
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let macUser = Table("usermac")
            let birthDay = Expression<String?>("birthday")
            let DF = DateFormatter()
            DF.dateFormat = "dd.MM.yyyy"
            for i in try db.prepare(macUser.select(birthDay)){
                txt = i[birthDay] ?? DF.string(from: Date.now)
            }
            return DF.date(from: txt)!
        }
        catch {
            print(error)
            return Date.now
        }
    }
    
    func getPreloadDoc() -> doc {
        do {
            var vrach = ""
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let macUser = Table("usermac")
            let _vrach = Expression<String?>("doc")
            for i in try db.prepare(macUser.select(_vrach)){
                vrach = i[_vrach] ?? "Попова П.В."
            }
            switch vrach {
            case "Анопова А.Д.":
                return doc.Anopova
            case "Болотько Я.А.":
                return doc.Bolotko
            case "Дронова А.В.":
                return doc.Dronova
            case "Попова П.В.":
                return doc.Popova
            case "Ткачут А.С.":
                return doc.Tkachuk
            case "Васюкова Е.А.":
                return doc.Vasukova
            case "Пашкова К.В.":
                return doc.Pashkova
            default:
                return doc.without
            }
        }
        catch {
            print(error)
            return doc.Popova
        }
    }
    
    func getPreloadStartDate() -> Date {
        do {
            var txt: String = ""
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let macUser = Table("usermac")
            let datebegin = Expression<String?>("datebegin")
            let DF = DateFormatter()
            DF.dateFormat = "dd.MM.yyyy"
            for i in try db.prepare(macUser.select(datebegin)){
                txt = i[datebegin] ?? DF.string(from: Date.now)
            }
            return DF.date(from: txt)!
        }
        catch {
            print(error)
            return Date.now
        }
    }
    
    func getPreloadWeek() -> [Double] {
        do {
            var w = 20
            var d = 3
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let macUser = Table("usermac")
            let weekOfStart = Expression<Int?>("week")
            let dayOfStart = Expression<Int?>("day")
            for i in try db.prepare(macUser.select(weekOfStart, dayOfStart)){
                w = i[weekOfStart] ?? 20
                d = i[dayOfStart] ?? 3
            }
            return [Double(w), Double(d)]
        }
        catch {
            print(error)
            return [20, 3]
        }
    }
    
    func getVersionName(number: Int) -> String {
        switch number {
        case 1: return "Dia"
        case 2: return "GDM"
        case 3: return "MS"
        case 4: return "PCOS"
        default:
            return "None"
        }
    }
}
