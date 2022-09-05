import Foundation
import SQLite

struct FoodList: Identifiable, Hashable {
    let id = UUID()
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
    @Published var CatObj = [CategoryList]()
    @Published var FoodID = UUID()
    @Published var CatID = UUID()
    func GetFoodItemsByName(_name: String) -> Void {
        do {
            var Food1 = [FoodList]()
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let foodItems = Table("food")
            let food = Expression<String>("name")
            let pr = Expression<Double>("prot")
            let car = Expression<Double>("carbo")
            let f = Expression<Double>("fat")
            let g = Expression<Double?>("gi")
            let rating = Expression<Int?>("favor")
            var GI = ""
            for i in try db.prepare(foodItems.select(food, pr, car, f, g, rating).filter(food.like("%\(_name)%")).order(food).limit(30)){
                if i[g] != nil {
                    GI = "\(i[g]!)"
                } else {
                    GI = ""
                }
                Food1.append(FoodList(name: "\(i[food])", prot: "\(i[pr])", carbo: "\(i[car])", fat: "\(i[f])", gi: GI, rating: i[rating] ?? 0))
            }
            self.FoodObj = Food1
        }
        catch {
            print(error)
        }
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

    func GetFoodCategoryItems(_category: String) -> Void {
        do {
            self.FoodObj.removeAll()
            var FoodObj = [FoodList]()
            FoodObj.removeAll()
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let foodItems = Table("food")
            let food = Expression<String>("name")
            let categoryRow = Expression<String>("category")
            let pr = Expression<Double>("prot")
            let car = Expression<Double>("carbo")
            let f = Expression<Double>("fat")
            let g = Expression<Double?>("gi")
            let rating = Expression<Int?>("favor")
            var GI = ""
            for i in try db.prepare(foodItems.select(food, pr, car, f, g, rating).filter(categoryRow == _category)){
                if i[g] != nil {
                    GI = "\(i[g]!)"
                } else {
                    GI = ""
                }
                FoodObj.append(FoodList(name: "\(i[food])", prot: "\(i[pr])", carbo: "\(i[car])", fat: "\(i[f])", gi: GI, rating: i[rating] ?? 0))
            }
            self.FoodObj = FoodObj
        }
        catch {
            print(error)
        }
    }
    
    func handleRatingChange(i: Int) -> Void {
        if self.FoodObj[i].rating == 0 {
            self.FoodObj[i].rating = 1
        } else {
            self.FoodObj[i].rating = 0
        }
    }
}

func SaveToDB(FoodName: String, gram: String, selectedDate: Date, selectedType: String) {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let diary = Table("diary")
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
        try db.run(diary.insert(foodName <- FoodName, g <- gram, date <- selectDate, time <- dtime,timeStamp <- realDateTime, type <- selectedType, picker <- dtime+" "+selectDate))
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

func changeRating(_name: String, _rating: Int) -> Void {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let food = Table("food")
        let rating = Expression<Int?>("favor")
        let name = Expression<String>("name")
        if _rating == 0 {
            try db.run(food.filter(name == _name).update(rating <- 1))
        } else {
            try db.run(food.filter(name == _name).update(rating <- 0))
        }
    }
    catch {
        print(error)
    }
}
