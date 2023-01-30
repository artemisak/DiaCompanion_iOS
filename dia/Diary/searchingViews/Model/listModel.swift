//
//  listModel.swift
//  listing
//
//  Created by Артём Исаков on 02.01.2023.
//

import Foundation
import SQLite3

enum foodCategories: String, CaseIterable, Identifiable {
    case alcohol = "Алкогольные напитки"
    case potato = "Блюда из картофеля, овощей и грибов"
    case croup = "Блюда из круп"
    case meat = "Блюда из мяса и мясных продуктов"
    case fish = "Блюда из рыбы, морепродуктов и раков"
    case curd = "Блюда из творога"
    case eggs = "Бдюда из яиц"
    case nuts = "Бобовые, орехи, продукты из бобовых"
    case fastMeal = "Быстрое питание"
    case additionalItems = "Вспомогательные продукты"
    case garnish = "Гарниры"
    case cookedMeal = "Готовые завтраки"
    case kidsMeal = "Детское питание"
    case diabeticItems = "Диабетические продукты"
    case oilAndFat = "Жиры и масла"
    case snacks = "Закуски"
    case greenAndVegetables = "Зелень и овощные продукты"
    case grain = "Зерно, мука"
    case pasta = "Злаки и макароны"
    case breakfastGrains = "Злаки на завтрак"
    case sausages =  "Колбасы"
    case bakery = "Кондитерские изделия"
    case chocolate = "Конфеты, шоколад"
    case milkAndEggs = "Молочные и яичные продукты"
    case milk = "Молочные продукты"
    case seafood = "Морепродукты"
    case meatItems = "Мясо и мясные продуты"
    case drinks = "Напитки"
    case vegetables = "Овощи"
    case folksMeal = "Пища коренных народов"
    case beef = "Продукты из говядины"
    case nutsProduce = "Продукты из орехов и семян"
    case chikenProducce = "Продуты из птицы"
    case pigProduce = "Продукты из свинины"
    case lamb = "Продукты из баранины, телятины и дичи"
    case restaurantFood = "Ресторанная еда"
    case fishAndFishItems = "Рыба и рыбные продукты"
    case sweetes = "Сладости"
    case sausagesAndMeatFood = "Сосиски и мясные блюда"
    case sauce = "Соусы"
    case spice = "Специи и травы"
    case soup = "Супы"
    case cheese = "Сыры"
    case fruits = "Фрукты и фруктовые соки"
    case bread = "Хлебобулочные изделия"
    case coldMeal = "Холодные блюда"
    case barries = "Ягоды, варенье"
    var id : Self { self }
}

enum fillerRule {
    case upGI
    case downGI
    case relevant
}

enum varToSave {
    case addedFoodItems
    case editingFoodItems
    case recipeFoodItems
}

struct foodGroups: Identifiable, Hashable {
    var id = UUID()
    var category: String
}

struct foodItem: Identifiable, Hashable {
    var id = UUID()
    var table_id: Int
    var name: String
    var prot: Double
    var fat: Double
    var carbo: Double
    var kkal: Double
    var gi: Double
    var index: Int?
    var position: Int?
    var gram: Double?
    var gl: Double {
        if self.gram != nil {
            return self.carbo*(self.gram!/100)*self.gi/100
        } else {
            return self.carbo*self.gi/100
        }
    }
}

class foodCollections: ObservableObject {
    @Published var textToSearch: String  = ""
    @Published var groupToSearch: String = ""
    @Published var rule: fillerRule = .relevant
    @Published var showListToolbar: Bool = false
    
    @Published var listOfGroups = [foodGroups]()
    @Published var listOfFood = [foodItem]()
    @Published var listOfPinnedFood = [foodItem]()
    @Published var listOfFoodInGroups = [foodItem]()
    @Published var listOfPinnedFoodInGroups = [foodItem]()

    @Published var selectedItem: foodItem?
    @Published var whereToSave: varToSave = .addedFoodItems
    @Published var addedFoodItems = [foodItem]()
    @Published var editedFoodItems = [foodItem]()
    @Published var recipeFoodItems = [foodItem]()
    
    private var _resultsOfSearch = [foodItem]()
    private var _position: Int = 0
    private var _lastVisibleIndex: Int = 0
        
    func resetConfigurationValues() {
        textToSearch = ""
        groupToSearch = ""
        rule = .relevant
        showListToolbar = false
    }
    
    func retrieveCat() {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        
        var temp = [foodGroups]()
        var db: OpaquePointer?
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("Error opening database")
            sqlite3_close(db)
            db = nil
            return
        }
        
        var statement: OpaquePointer?
        let sql = "SELECT*FROM foodGroups"
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let _category = String(cString: sqlite3_column_text(statement, 1))
            temp.append(foodGroups(category: _category))
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error finalizing prepared statement: \(errmsg)")
        }
        statement = nil
        
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
        db = nil
        
        listOfGroups = temp
    }
 
    func fillList() {
        _lastVisibleIndex = 0
        _position = 0
        
        var temp = [foodItem]()
        
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path1 = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        
        var db: OpaquePointer?
        guard sqlite3_open(path1, &db) == SQLITE_OK else {
            print("Error opening database")
            sqlite3_close(db)
            db = nil
            return
        }
        
        var statement: OpaquePointer?
        var sql = ""
        if textToSearch != "" && groupToSearch != "" {
            var name = textToSearch.components(separatedBy: " ")
            name.removeAll(where: {$0.isEmpty})
            for i in 0..<name.count {
                switch i {
                case 0:
                    sql += "SELECT DISTINCT _id, name, prot, fat, carbo, ec, gi, favor FROM (SELECT _id, name, prot, fat, carbo, ec, gi, favor, 1 AS sort FROM food WHERE name LIKE '\(name[i].firstCapitalized)%' AND category = '\(groupToSearch)' UNION SELECT _id, name, prot, fat, carbo, ec, gi, favor, 2 FROM food WHERE name LIKE '_%\(name[i].lowercased())%' AND category = '\(groupToSearch)' ORDER BY sort ASC)"
                case 1:
                    sql += " WHERE name LIKE '%\(name[i])%' OR name LIKE '%\(name[i].firstCapitalized)%'"
                default:
                    sql += " AND name LIKE '%\(name[i])%' OR name LIKE '%\(name[i].firstCapitalized)%'"
                }
            }
        } else if  textToSearch == "" && groupToSearch != "" {
            sql = "SELECT _id, name, prot, fat, carbo, ec, gi, favor FROM food WHERE category = '\(groupToSearch)'"
        } else if textToSearch != "" && groupToSearch == "" {
            var name = textToSearch.components(separatedBy: " ")
            name.removeAll(where: {$0.isEmpty})
            for i in 0..<name.count {
                switch i {
                case 0:
                    sql += "SELECT DISTINCT _id, name, prot, fat, carbo, ec, gi, favor FROM (SELECT _id, name, prot, fat, carbo, ec, gi, favor, 1 AS sort FROM food WHERE name LIKE '\(name[i].firstCapitalized)%' UNION SELECT _id, name, prot, fat, carbo, ec, gi, favor, 2 FROM food WHERE name LIKE '_%\(name[i].lowercased())%' ORDER BY sort ASC)"
                case 1:
                    sql += " WHERE name LIKE '%\(name[i])%' OR name LIKE '%\(name[i].firstCapitalized)%'"
                default:
                    sql += " AND name LIKE '%\(name[i])%' OR name LIKE '%\(name[i].firstCapitalized)%'"
                }
            }
        }
        
        switch rule {
        case .relevant:
            sql += ""
        case .downGI:
            sql += " ORDER BY gi ASC"
        case .upGI:
            sql += " ORDER BY gi DESC"
        }
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let _id = Int(sqlite3_column_int64(statement, 0))
            let _name = String(cString: sqlite3_column_text(statement, 1))
            
            var _prot = 0.0
            if sqlite3_column_type(statement, 2) == 2 {
                _prot = sqlite3_column_double(statement, 2)
            }
            var _fat = 0.0
            if sqlite3_column_type(statement, 3) == 2 {
                _fat = sqlite3_column_double(statement, 3)
            }
            var _carbo = 0.0
            if sqlite3_column_type(statement, 4) == 2 {
                _carbo = sqlite3_column_double(statement, 4)
            }
            var _kkal = 0.0
            if sqlite3_column_type(statement, 5) == 2 {
                _kkal = sqlite3_column_double(statement, 5)
            }
            var _gi = 0.0
            if sqlite3_column_type(statement, 6) == 2 {
                _gi = sqlite3_column_double(statement, 6)
            }
            var _index = 0
            if sqlite3_column_type(statement, 7) == 1 {
                _index = Int(sqlite3_column_int64(statement, 7))
            }
            
            temp.append(foodItem(table_id: _id, name: _name, prot: _prot, fat: _fat, carbo: _carbo, kkal: _kkal, gi: _gi, index: _index, position: _position))
            _position += 1
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error finalizing prepared statement: \(errmsg)")
        }
        statement = nil
        
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
        db = nil
        
        _resultsOfSearch = temp
        
        let tempSlice0 = temp.filter({$0.index == 0})
        let tempSlice1 = temp.filter({$0.index == 1})
        var upperBound = 0
        if tempSlice0.count < 15 && tempSlice0.count != 0 {
            upperBound = tempSlice0.count-1
            if groupToSearch != "" {
                listOfFoodInGroups = Array(tempSlice0[0..<upperBound])
                listOfPinnedFoodInGroups = tempSlice1
                showListToolbar = true
            } else {
                listOfFood = Array(tempSlice0[0..<upperBound])
                listOfPinnedFood = tempSlice1
                showListToolbar = true
            }
        } else if tempSlice0.count >= 15 && tempSlice0.count != 0 {
            upperBound = 15
            if groupToSearch != "" {
                listOfFoodInGroups = Array(tempSlice0[0..<upperBound])
                listOfPinnedFoodInGroups = tempSlice1
                showListToolbar = true
            } else {
                listOfFood = Array(tempSlice0[0..<upperBound])
                listOfPinnedFood = tempSlice1
                showListToolbar = true
            }
        } else {
            listOfFood = []
            listOfPinnedFood = []
            listOfFoodInGroups = []
            listOfPinnedFoodInGroups = []
        }
    }
    
    func appendList(item_id: UUID) {
        if getItemID(item_id, 0)! > _lastVisibleIndex {
            _lastVisibleIndex = getItemID(item_id, 0)!
        }
        if (_lastVisibleIndex == listOfFood.count-1) && (listOfFood.count + listOfPinnedFood.count != _resultsOfSearch.count){
            let lowerBound =  listOfFood[_lastVisibleIndex].position
            let upperBound = _resultsOfSearch.filter({$0.index == 0 && $0.position! > lowerBound!}).count < 15 ? _resultsOfSearch.filter({$0.index == 0 && $0.position! > lowerBound!}).count : 15
            listOfFood.append(contentsOf: Array(_resultsOfSearch.filter({$0.index == 0 && $0.position! > lowerBound!})[0..<upperBound]))
        }
    }
    
    func appendListInGroups(item_id: UUID) {
        if getItemID(item_id, 2)! > _lastVisibleIndex {
            _lastVisibleIndex = getItemID(item_id, 2)!
        }
        if (_lastVisibleIndex == listOfFoodInGroups.count-1) && (listOfFoodInGroups.count + listOfPinnedFoodInGroups.count != _resultsOfSearch.count){
            let lowerBound =  listOfFoodInGroups[_lastVisibleIndex].position
            let upperBound = _resultsOfSearch.filter({$0.index == 0 && $0.position! > lowerBound!}).count < 15 ? _resultsOfSearch.filter({$0.index == 0 && $0.position! > lowerBound!}).count : 15
            listOfFoodInGroups.append(contentsOf: Array(_resultsOfSearch.filter({$0.index == 0 && $0.position! > lowerBound!})[0..<upperBound]))
        }
    }
    
    func pinRow(item_id: UUID, case_id: Int) {
        let idx = getItemID(item_id, case_id)!
        switch case_id {
        case 0:
            var temp = listOfFood[idx]
            temp.index = 1
            temp.id = UUID()
            listOfPinnedFood.insert(temp, at: listOfPinnedFood.count)
            changeDataBaseIndex(table_id: temp.table_id, 1)
        case 1:
            var temp = listOfPinnedFood[idx]
            temp.index = 0
            temp.id = UUID()
            if temp.position! < listOfFood.last!.position! {
                listOfFood.insert(temp, at: temp.position!)
            } else {
                _resultsOfSearch[_resultsOfSearch.firstIndex(where: {$0.id == item_id})!].index = 0
            }
            changeDataBaseIndex(table_id: temp.table_id, 0)
        default:
            return
        }
    }
    
    func pinRowInGroups(item_id: UUID, case_id: Int) {
        let idx = getItemID(item_id, case_id)!
        switch case_id {
        case 2:
            var temp = listOfFoodInGroups[idx]
            temp.index = 1
            temp.id = UUID()
            listOfPinnedFoodInGroups.insert(temp, at: listOfPinnedFoodInGroups.count)
            changeDataBaseIndex(table_id: temp.table_id, 1)
        case 3:
            var temp = listOfPinnedFoodInGroups[idx]
            temp.index = 0
            temp.id = UUID()
            if temp.position! < listOfFoodInGroups.last!.position! {
                listOfFoodInGroups.insert(temp, at: temp.position!)
            } else {
                _resultsOfSearch[_resultsOfSearch.firstIndex(where: {$0.id == item_id})!].index = 0
            }
            changeDataBaseIndex(table_id: temp.table_id, 0)
        default:
            return
        }
    }
    
    func removeRow(item_id: UUID, case_id: Int) {
        let idx = getItemID(item_id, case_id)!
        switch case_id {
        case 0:
            listOfFood.remove(at: idx)
        case 1:
            listOfPinnedFood.remove(at: idx)
        default:
            return
        }
    }
    
    func removeRowInGroups(item_id: UUID, case_id: Int) {
        let idx = getItemID(item_id, case_id)!
        switch case_id {
        case 2:
            listOfFoodInGroups.remove(at: idx)
        case 3:
            listOfPinnedFoodInGroups.remove(at: idx)
        default:
            return
        }
    }
    
    func getItemID(_ item_id: UUID, _ case_id: Int) -> Int? {
        switch case_id {
        case 0:
            guard let idx = listOfFood.firstIndex(where: {$0.id == item_id}) else {
                fatalError("Not found element in collection")
            }
            return idx
        case 1:
            guard let idx = listOfPinnedFood.firstIndex(where: {$0.id == item_id}) else {
                fatalError("Not found element in collection")
            }
            return idx
        case 2:
            guard let idx = listOfFoodInGroups.firstIndex(where: {$0.id == item_id}) else {
                fatalError("Not found element in collection")
            }
            return idx
        case 3:
            guard let idx = listOfPinnedFoodInGroups.firstIndex(where: {$0.id == item_id}) else {
                fatalError("Not found element in collection")
            }
            return idx
        default:
            return nil
        }
    }
    
    func changeDataBaseIndex(table_id: Int, _ index: Int) {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        
        var db: OpaquePointer?
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("Error opening database")
            sqlite3_close(db)
            db = nil
            return
        }
        
        var statement: OpaquePointer?
        let sql = "UPDATE food SET favor = \(index) WHERE _id = \(table_id)"
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Could not update row.")
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error finalizing prepared statement: \(errmsg)")
        }
        statement = nil
        
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
        db = nil
    }
}
