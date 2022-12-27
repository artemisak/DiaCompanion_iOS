import Foundation
import SQLite

enum foodListErorrs: Error {
    case generalError
}

struct FoodList: Identifiable, Hashable {
    let id = UUID()
    let table_id: Int
    let name: String
    let prot: String
    let carbo: String
    let fat: String
    let gi: String
    var rating: Int
    
}

struct CategoryList: Identifiable, Hashable {
    let id = UUID()
    let name: String
    
}

class Food: ObservableObject {
    @Published var FoodObj = [FoodList]()
    @Published var inCatFoodObj = [FoodList]()
    @Published var CatObj = [CategoryList]()
    @Published var FoodID = UUID()
    @Published var CatID = UUID()
    
    @MainActor
    func GetFoodItemsByName(_name: String) async -> Void {
        let res = Task {
            var Food1 = [FoodList]()
            var name = _name.components(separatedBy: " ")
            name.removeAll(where: {$0.isEmpty})
            do {

                let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let path = documents + "/diacompanion.db"
                let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
                _=copyDatabaseIfNeeded(sourcePath: sourcePath)
                let db = try Connection(path)
                var sql = ""
                for i in 0..<name.count {
                    if i == 0 {
                        sql += "SELECT * FROM (SELECT _id, name, prot, carbo, fat, gi, favor, 1 AS filter FROM food WHERE name LIKE '\(name[i].firstCapitalized)%' ORDER BY name ASC) UNION SELECT * FROM ( SELECT _id, name, prot, carbo, fat, gi, favor, 2 AS filter FROM food WHERE name LIKE '_%\(name[i].lowercased())%' ORDER BY name ASC)"
                        sql = "SELECT * FROM (\(sql))"
                    }
                    else if i == 1 {
                        sql += " WHERE name LIKE '%\(name[i])%' OR name LIKE '%\(name[i].firstCapitalized)%'"
                    }
                    else {
                        sql += " AND name LIKE '%\(name[i])%' OR name LIKE '%\(name[i].firstCapitalized)%'"
                    }
                }
                sql += " ORDER BY filter ASC"
                let stmt = try db.prepare(sql)
                for row in stmt {
                    Food1.append(FoodList(table_id: Int("\(row[0]!)")!, name: "\(row[1]!)", prot: "\(row[2]!)", carbo: "\(row[3]!)", fat: "\(row[4]!)", gi: "\(row[5] ?? 0)", rating: Int("\(row[6] ?? 0)")!))
                }
            }
            catch {
                print(error)
            }
            return Food1
        }
        await self.FoodObj = res.value
    }
    
    func FillFoodCategoryList() -> Void {
        do {
            var Food1 = [CategoryList]()
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let food = Table("foodGroups")
            let category = Expression<String>("category")
            for i in try db.prepare(food.select(category)){
                Food1.append(CategoryList(name: "\(i[category])"))
            }
            self.CatObj = Food1
        }
        catch {
            print(error)
        }
    }
    
    @MainActor
    func GetFoodCategoryItems(_category: String) async -> Void {
        let res = Task {
            var FoodObj = [FoodList]()
            do {
                let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let path = documents + "/diacompanion.db"
                let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
                _=copyDatabaseIfNeeded(sourcePath: sourcePath)
                let db = try Connection(path)
                let foodItems = Table("food")
                let table_id = Expression<Int>("_id")
                let food = Expression<String>("name")
                let categoryRow = Expression<String>("category")
                let pr = Expression<Double>("prot")
                let car = Expression<Double>("carbo")
                let f = Expression<Double>("fat")
                let g = Expression<Double?>("gi")
                let rating = Expression<Int?>("favor")
                var GI = ""
                for i in try db.prepare(foodItems.select(table_id, food, pr, car, f, g, rating).filter(categoryRow == _category)){
                    if i[g] != nil {
                        GI = "\(i[g]!)"
                    } else {
                        GI = ""
                    }
                    FoodObj.append(FoodList(table_id: i[table_id], name: "\(i[food])", prot: "\(i[pr])", carbo: "\(i[car])", fat: "\(i[f])", gi: GI, rating: i[rating] ?? 0))
                }
            }
            catch {
                print(error)
            }
            return FoodObj
        }
        return await self.inCatFoodObj = res.value
    }
    
    func handleRatingChange(i: Int, array_index: Int) -> Void {
        if array_index == 0 {
            if self.inCatFoodObj[i].rating == 0 {
                self.inCatFoodObj[i].rating = 1
            } else {
                self.inCatFoodObj[i].rating = 0
            }
        } else {
            if self.FoodObj[i].rating == 0 {
                self.FoodObj[i].rating = 1
            } else {
                self.FoodObj[i].rating = 0
            }
        }
    }
    
    func handleDeleting(i: Int, array_index: Int) -> Void {
        if array_index == 0 {
            inCatFoodObj.remove(at: i)
        } else {
            FoodObj.remove(at: i)
        }
    }

}

func SaveToDB(FoodName: String, gram: String, table_id: String, selectedDate: Date, selectedType: String) {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let diary = Table("diary")
        let id_food = Expression<Int>("id_food")
        let foodName = Expression<String>("foodName")
        let g = Expression<String>("g")
        let date = Expression<String>("date")
        let time = Expression<String>("time")
        let timeStamp = Expression<String>("timeStamp")
        let type = Expression<String>("foodType")
        let picker = Expression<String>("dateTime")
        
        let dateFormatter = DateFormatter()
        let dateFormatter1 = DateFormatter()
        let dateFormatter2 = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
        dateFormatter1.locale = Locale(identifier: "ru_RU")
        dateFormatter1.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
        dateFormatter2.locale = Locale(identifier: "ru_RU")
        dateFormatter2.setLocalizedDateFormatFromTemplate("HH:mm")
        
        let realDateTime = dateFormatter.string(from: Date.now)
        let selectDate = dateFormatter1.string(from: selectedDate)
        let dtime = dateFormatter2.string(from: selectedDate)
        try db.run(diary.insert(id_food <- convertToInt(txt: table_id), foodName <- FoodName, g <- gram, date <- selectDate, time <- dtime,timeStamp <- realDateTime, type <- selectedType, picker <- dtime+" "+selectDate))
    }
    catch {
        print(error)
    }
}

func checkIfAlreadyEx(selectedDate: Date, idForDelete: [Int]) -> Bool {
    if idForDelete.isEmpty {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let diary = Table("diary")
            let date = Expression<String>("date")
            let time = Expression<String>("time")
            let dateFormatter1 = DateFormatter()
            let dateFormatter2 = DateFormatter()
            dateFormatter1.locale = Locale(identifier: "ru_RU")
            dateFormatter1.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
            dateFormatter2.locale = Locale(identifier: "ru_RU")
            dateFormatter2.setLocalizedDateFormatFromTemplate("HH:mm")
            if Array(try db.prepare(diary.select(date,time).filter(date == dateFormatter1.string(from: selectedDate) && time == dateFormatter2.string(from: selectedDate)))).isEmpty{
                return false
            } else {
                return true
            }
        }
        catch {
            print(error)
            return true
        }
    } else {
        return false
    }
}

func addPredictedRecord(selectedDate: Date, selectedType: String, BG0: Double, BG1: Double) {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let predicted = Table("predicted")
        let _timeStamp = Expression<String>("timeStamp")
        let _date = Expression<String>("date")
        let _time = Expression<String>("time")
        let _priem = Expression<String>("priem")
        let _BG0 = Expression<Double>("BG0")
        let _BG1 = Expression<Double>("BG1")
        let dateFormatter = DateFormatter()
        let dateFormatter1 = DateFormatter()
        let dateFormatter2 = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
        dateFormatter1.locale = Locale(identifier: "ru_RU")
        dateFormatter1.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
        dateFormatter2.locale = Locale(identifier: "ru_RU")
        dateFormatter2.setLocalizedDateFormatFromTemplate("HH:mm")
        let realDateTime = dateFormatter.string(from: Date.now)
        let selectDate = dateFormatter1.string(from: selectedDate)
        let dtime = dateFormatter2.string(from: selectedDate)
        try db.run(predicted.insert(_timeStamp <- realDateTime, _date <- selectDate, _time <- dtime, _priem <- selectedType, _BG0 <- BG0, _BG1 <- BG1))
    }
    catch {
        print(error)
    }
}

func changeRating(_id: Int, _rating: Int) -> Void {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let food = Table("food")
        let rating = Expression<Int?>("favor")
        let id = Expression<Int>("_id")
        if _rating == 0 {
            try db.run(food.filter(id == _id).update(rating <- 1))
        } else {
            try db.run(food.filter(id == _id).update(rating <- 0))
        }
    }
    catch {
        print(error)
    }
}

func addNewFoodN(items: [foodToSave], newReceitName: String, category: String) {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let food = Table("food")
        let table_id = Expression<Int>("_id")
        let foodName = Expression<String>("name")
        let cat = Expression<String>("category")
        let carbo = Expression<Double?>("carbo")
        let prot = Expression<Double?>("prot")
        let fat = Expression<Double?>("fat")
        let ec = Expression<Double?>("ec")
        let gi = Expression<Double?>("gi")
        let water = Expression<Double?>("water")
        let nzhk = Expression<Double?>("nzhk")
        let hol = Expression<Double?>("hol")
        let pv = Expression<Double?>("pv")
        let zola = Expression<Double?>("zola")
        let na = Expression<Double?>("na")
        let k = Expression<Double?>("k")
        let ca = Expression<Double?>("ca")
        let mg = Expression<Double?>("mg")
        let p = Expression<Double?>("p")
        let fe = Expression<Double?>("fe")
        let a = Expression<Double?>("a")
        let b1 = Expression<Double?>("b1")
        let b2 = Expression<Double?>("b2")
        let rr = Expression<Double?>("rr")
        let c = Expression<Double?>("c")
        let re = Expression<Double?>("re")
        let kar = Expression<Double?>("kar")
        let mds = Expression<Double?>("mds")
        let kr = Expression<Double?>("kr")
        let te = Expression<Double?>("te")
        let ok = Expression<Double?>("ok")
        let ne = Expression<Double?>("ne")
        let zn = Expression<Double?>("zn")
        let cu = Expression<Double?>("cu")
        let mn = Expression<Double?>("mn")
        let se = Expression<Double?>("se")
        let b5 = Expression<Double?>("b5")
        let b6 = Expression<Double?>("b6")
        let fol = Expression<Double?>("fol")
        let b9 = Expression<Double?>("b9")
        let dfe = Expression<Double?>("dfe")
        let holin = Expression<Double?>("holin")
        let b12 = Expression<Double?>("b12")
        let ear = Expression<Double?>("ear")
        let a_kar = Expression<Double?>("a_kar")
        let b_kript = Expression<Double?>("b_kript")
        let likopin = Expression<Double?>("likopin")
        let lut_z = Expression<Double?>("lut_z")
        let vit_e = Expression<Double?>("vit_e")
        let vit_d = Expression<Double?>("vit_d")
        let d_mezd = Expression<Double?>("d_mezd")
        let vit_k = Expression<Double?>("vit_k")
        let mzhk = Expression<Double?>("mzhk")
        let pzhk = Expression<Double?>("pzhk")
        let w_1ed = Expression<Double?>("w_1ed")
        let op_1ed = Expression<Double?>("op_1ed")
        let w_2ed = Expression<Double?>("w_2ed")
        let op_2ed = Expression<Double?>("op_2ed")
        let proc_pot = Expression<Double?>("proc_pot")
        let additional = Expression<Double?>("additional")
        let favor = Expression<Int?>("favor")
        var parameters: [[Double]] = []
        for i in items {
            let arg = "\(i.name)".components(separatedBy: "////")
            for j in try db.prepare(food.filter(table_id == convertToInt(txt: arg[2]) && foodName == arg[0]).limit(1)){
                parameters.append([(j[carbo] ?? 0.0) * Double(arg[1])!/100,
                                   (j[prot] ?? 0.0) * Double(arg[1])!/100,
                                   (j[fat] ?? 0.0) * Double(arg[1])!/100,
                                   (j[ec] ?? 0.0) * Double(arg[1])!/100,
                                   (j[gi] ?? 0.0) * (j[carbo] ?? 0.0) * Double(arg[1])!/100,
                                   (j[water] ?? 0.0) * Double(arg[1])!/100,
                                   (j[nzhk] ?? 0.0) * Double(arg[1])!/100,
                                   (j[hol] ?? 0.0) * Double(arg[1])!/100,
                                   (j[pv] ?? 0.0) * Double(arg[1])!/100,
                                   (j[zola] ?? 0.0) * Double(arg[1])!/100,
                                   (j[na] ?? 0.0) * Double(arg[1])!/100,
                                   (j[k] ?? 0.0) * Double(arg[1])!/100,
                                   (j[ca] ?? 0.0) * Double(arg[1])!/100,
                                   (j[mg] ?? 0.0) * Double(arg[1])!/100,
                                   (j[p] ?? 0.0) * Double(arg[1])!/100,
                                   (j[fe] ?? 0.0) * Double(arg[1])!/100,
                                   (j[a] ?? 0.0) * Double(arg[1])!/100,
                                   (j[b1] ?? 0.0) * Double(arg[1])!/100,
                                   (j[b2] ?? 0.0) * Double(arg[1])!/100,
                                   (j[rr] ?? 0.0) * Double(arg[1])!/100,
                                   (j[c] ?? 0.0) * Double(arg[1])!/100,
                                   (j[re] ?? 0.0) * Double(arg[1])!/100,
                                   (j[kar] ?? 0.0) * Double(arg[1])!/100,
                                   (j[mds] ?? 0.0) * Double(arg[1])!/100,
                                   (j[kr] ?? 0.0) * Double(arg[1])!/100,
                                   (j[te] ?? 0.0) * Double(arg[1])!/100,
                                   (j[ok] ?? 0.0) * Double(arg[1])!/100,
                                   (j[ne] ?? 0.0) * Double(arg[1])!/100,
                                   (j[zn] ?? 0.0) * Double(arg[1])!/100,
                                   (j[cu] ?? 0.0) * Double(arg[1])!/100,
                                   (j[mn] ?? 0.0) * Double(arg[1])!/100,
                                   (j[se] ?? 0.0) * Double(arg[1])!/100,
                                   (j[b5] ?? 0.0) * Double(arg[1])!/100,
                                   (j[b6] ?? 0.0) * Double(arg[1])!/100,
                                   (j[fol] ?? 0.0) * Double(arg[1])!/100,
                                   (j[b9] ?? 0.0) * Double(arg[1])!/100,
                                   (j[dfe] ?? 0.0) * Double(arg[1])!/100,
                                   (j[holin] ?? 0.0) * Double(arg[1])!/100,
                                   (j[b12] ?? 0.0) * Double(arg[1])!/100,
                                   (j[ear] ?? 0.0) * Double(arg[1])!/100,
                                   (j[a_kar] ?? 0.0) * Double(arg[1])!/100,
                                   (j[b_kript] ?? 0.0) * Double(arg[1])!/100,
                                   (j[likopin] ?? 0.0) * Double(arg[1])!/100,
                                   (j[lut_z] ?? 0.0) * Double(arg[1])!/100,
                                   (j[vit_e] ?? 0.0) * Double(arg[1])!/100,
                                   (j[vit_d] ?? 0.0) * Double(arg[1])!/100,
                                   (j[d_mezd] ?? 0.0) * Double(arg[1])!/100,
                                   (j[vit_k] ?? 0.0) * Double(arg[1])!/100,
                                   (j[mzhk] ?? 0.0) * Double(arg[1])!/100,
                                   (j[pzhk] ?? 0.0) * Double(arg[1])!/100,
                                   (j[w_1ed] ?? 0.0) * Double(arg[1])!/100,
                                   (j[op_1ed] ?? 0.0) * Double(arg[1])!/100,
                                   (j[w_2ed] ?? 0.0) * Double(arg[1])!/100,
                                   (j[op_2ed] ?? 0.0) * Double(arg[1])!/100,
                                   (j[proc_pot] ?? 0.0) * Double(arg[1])!/100])
            }
        }
                
        for i in 0..<parameters.count-1 {
            for j in 0..<parameters[i].count {
                parameters[i+1][j] = parameters[i][j] + parameters[i+1][j]
            }
        }
        var summOfParam = parameters.last!
        summOfParam[4] = round(summOfParam[4]/summOfParam[0]*100)/100
        
        var num = 1
        var resultingName = newReceitName
        while Array(try db.prepare(food.filter(foodName == resultingName))).count != 0 {
            resultingName = newReceitName + " " + "(рецепт №\(num))"
            num += 1
        }
        
        summOfParam = summOfParam.map({round($0*10)/10})
        
        try db.run(food.insert(foodName <- resultingName, cat <- category, carbo <- summOfParam[0], prot <- summOfParam[1], fat <- summOfParam[2], ec <- summOfParam[3], gi <- summOfParam[4], water <- summOfParam[5], nzhk <- summOfParam[6], hol <- summOfParam[7], pv <- summOfParam[8], zola <- summOfParam[9], na <- summOfParam[10], k <- summOfParam[11], ca <- summOfParam[12], mg <- summOfParam[13], p <- summOfParam[14], fe <- summOfParam[15], a <- summOfParam[16], b1 <- summOfParam[17], b2 <- summOfParam[18], rr <- summOfParam[19], c <- summOfParam[20], re <- summOfParam[21], kar <- summOfParam[22], mds <- summOfParam[23], kr <- summOfParam[24], te <- summOfParam[25], ok <- summOfParam[26], ne <- summOfParam[27], zn <- summOfParam[28], cu <- summOfParam[29], mn <- summOfParam[30], se <- summOfParam[31], b5 <- summOfParam[32], b6 <- summOfParam[33], fol <- summOfParam[34], b9 <- summOfParam[35], dfe <- summOfParam[36], holin <- summOfParam[37], b12 <- summOfParam[38], ear <- summOfParam[39], a_kar <- summOfParam[40], b_kript <- summOfParam[41], likopin <- summOfParam[42], lut_z <- summOfParam[43], vit_e <- summOfParam[44], vit_d <- summOfParam[45], d_mezd <- summOfParam[46], vit_k <- summOfParam[47], mzhk <- summOfParam[48], pzhk <- summOfParam[49], w_1ed <- summOfParam[50], op_1ed <- summOfParam[51], w_2ed <- summOfParam[52], op_2ed <- summOfParam[53], proc_pot <- summOfParam[54], additional <- 0, favor <- 1))
    }
    catch {
        print(error)
    }
}

func deleteFood(_id: Int) -> Void {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let food = Table("food")
        let id = Expression<Int>("_id")
        try db.run(food.filter(id == _id).delete())
    }
    catch {
        print(error)
    }
}

func restoreDB() -> Bool {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/reserved.db"
        let sourcePath = Bundle.main.path(forResource: "reserved", ofType: "db")!
        _=copyBackDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let foodTable = Table("food")
        let foodN = Expression<String>("name")
        let cat = Expression<String>("category")
        let carbo = Expression<Double?>("carbo")
        let prot = Expression<Double?>("prot")
        let fat = Expression<Double?>("fat")
        let ec = Expression<Double?>("ec")
        let gi = Expression<Double?>("gi")
        let water = Expression<Double?>("water")
        let nzhk = Expression<Double?>("nzhk")
        let hol = Expression<Double?>("hol")
        let pv = Expression<Double?>("pv")
        let zola = Expression<Double?>("zola")
        let na = Expression<Double?>("na")
        let k = Expression<Double?>("k")
        let ca = Expression<Double?>("ca")
        let mg = Expression<Double?>("mg")
        let p = Expression<Double?>("p")
        let fe = Expression<Double?>("fe")
        let a = Expression<Double?>("a")
        let b1 = Expression<Double?>("b1")
        let b2 = Expression<Double?>("b2")
        let rr = Expression<Double?>("rr")
        let c = Expression<Double?>("c")
        let re = Expression<Double?>("re")
        let kar = Expression<Double?>("kar")
        let mds = Expression<Double?>("mds")
        let kr = Expression<Double?>("kr")
        let te = Expression<Double?>("te")
        let ok = Expression<Double?>("ok")
        let ne = Expression<Double?>("ne")
        let zn = Expression<Double?>("zn")
        let cu = Expression<Double?>("cu")
        let mn = Expression<Double?>("mn")
        let se = Expression<Double?>("se")
        let b5 = Expression<Double?>("b5")
        let b6 = Expression<Double?>("b6")
        let fol = Expression<Double?>("fol")
        let b9 = Expression<Double?>("b9")
        let dfe = Expression<Double?>("dfe")
        let holin = Expression<Double?>("holin")
        let b12 = Expression<Double?>("b12")
        let ear = Expression<Double?>("ear")
        let a_kar = Expression<Double?>("a_kar")
        let b_kript = Expression<Double?>("b_kript")
        let likopin = Expression<Double?>("likopin")
        let lut_z = Expression<Double?>("lut_z")
        let vit_e = Expression<Double?>("vit_e")
        let vit_d = Expression<Double?>("vit_d")
        let d_mezd = Expression<Double?>("d_mezd")
        let vit_k = Expression<Double?>("vit_k")
        let mzhk = Expression<Double?>("mzhk")
        let pzhk = Expression<Double?>("pzhk")
        let w_1ed = Expression<Double?>("w_1ed")
        let op_1ed = Expression<Double?>("op_1ed")
        let w_2ed = Expression<Double?>("w_2ed")
        let op_2ed = Expression<Double?>("op_2ed")
        let proc_pot = Expression<Double?>("proc_pot")
        let additional = Expression<Int?>("additional")
        let favor = Expression<Int?>("favor")
        
        let allDataCopy = Array(try db.prepare(foodTable))
        
        let documents2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path2 = documents2 + "/diacompanion.db"
        let sourcePath2 = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath2)
        let db2 = try Connection(path2)

        try db2.run(foodTable.delete())
        for i in allDataCopy {
            try db2.run(foodTable.insert(foodN <- i[foodN], cat <- i[cat], carbo <- i[carbo], prot <- i[prot], fat <- i[fat], ec <- i[ec], gi <- i[gi], water <- i[water], nzhk <- i[nzhk], hol <- i[hol], pv <- i[pv], zola <- i[zola], na <- i[na], k <- i[k], ca <- i[ca], mg <- i[mg], p <- i[p], fe <- i[fe], a <- i[a], b1 <- i[b1], b2 <- i[b2], rr <- i[rr], c <- i[c], re <- i[re], kar <- i[kar], mds <- i[mds], kr <- i[kr], te <- i[te], ok <- i[ok], ne <- i[ne], zn <- i[zn], cu <- i[cu], mn <- i[mn], se <- i[se], b5 <- i[b5], b6 <- i[b6], fol <- i[fol], b9 <- i[b9], dfe <- i[dfe], holin <- i[holin], b12 <- i[b12], ear <- i[ear], a_kar <- i[a_kar], b_kript <- i[b_kript], likopin <- i[likopin], lut_z <- i[lut_z], vit_e <- i[vit_e], vit_d <- i[vit_d], d_mezd <- i[d_mezd], vit_k <- i[vit_k], mzhk <- i[mzhk], pzhk <- i[pzhk], w_1ed <- i[w_1ed], op_1ed <- i[op_1ed], w_2ed <- i[w_2ed], op_2ed <- i[op_2ed], proc_pot <- i[proc_pot], additional <- i[additional], favor <- i[favor]))
        }
        return false
    }
    catch {
        print(error)
        return true
    }
}
