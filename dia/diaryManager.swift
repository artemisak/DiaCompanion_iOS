import Foundation
import SQLite

struct FoodList: Identifiable, Hashable {
    let name: String
    let prot: String
    let carbo: String
    let fat: String
    let gi: String
    let id = UUID()
}

struct CategoryList: Identifiable, Hashable {
    let name: String
    let id = UUID()
}

class Food: ObservableObject {
    @Published var FoodObj = [FoodList]()
    @Published var CatObj = [CategoryList]()
    
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
            var GI = ""
            for i in try db.prepare(foodItems.select(food, pr, car, f, g).filter(food.like("%\(_name)%")).order(food).limit(30)){
                if i[g] != nil {
                    GI = "\(i[g]!)"
                } else {
                    GI = ""
                }
                Food1.append(FoodList(name: "\(i[food])", prot: "\(i[pr])", carbo: "\(i[car])", fat: "\(i[f])", gi: GI))
            }
            self.FoodObj = Food1
        }
        catch {
            print(error)
        }
    }
    
    func FillFoodCategoryList() async -> Void {
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
    
    func GetFoodCategoryItems(_category: String) -> [FoodList] {
        do {
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
            var GI = ""
            for i in try db.prepare(foodItems.select(food, pr, car, f, g).filter(categoryRow == _category)){
                if i[g] != nil {
                    GI = "\(i[g]!)"
                } else {
                    GI = ""
                }
                FoodObj.append(FoodList(name: "\(i[food])", prot: "\(i[pr])", carbo: "\(i[car])", fat: "\(i[f])", gi: GI))
            }
            return FoodObj
        }
        catch {
            print(error)
            return []
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
        let picker = Expression<Date>("dateTime")
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
        try db.run(diary.insert(foodName <- FoodName, g <- gram, date <- selectDate, time <- dtime,timeStamp <- realDateTime, type <- selectedType, picker <- selectedDate))
    }
    catch {
        print(error)
    }
}


