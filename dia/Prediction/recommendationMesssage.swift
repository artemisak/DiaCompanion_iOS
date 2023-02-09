//
//  recommendationMesssage.swift
//  dia
//
//  Created by Артём Исаков on 15.08.2022.
//

import Foundation
import SQLite

struct recomendation: Identifiable, Hashable {
    var id = UUID()
    var text: String
}

func getMessage(highBGPredict: Bool, highBGBefore: Bool, moderateAmountOfCarbo: Bool, tooManyCarbo: Bool, unequalGLDistribution: Bool, highGI: Bool) -> [recomendation] {
    var temp  = [recomendation]()
    if highBGPredict {
        if highBGBefore {
            temp.append(recomendation(text: "Высокий уровень глюкозы до еды. Рекомендовано уменьшить количество углеводов во время перекусов. Если перекусов не было, проконсультируитесь с врачом."))
        }
        if moderateAmountOfCarbo {
            if (unequalGLDistribution) {
                temp.append(recomendation(text: "Уменьшите количество продуктов с высокой гликемической нагрузкой (ГН)."))
            } else if highGI {
                temp.append(recomendation(text: "Рекомендуется исключить из рациона или уменьшить количество продуктов с высоким гликемическим индексом (более 55)."))
            } else if tooManyCarbo {
                temp.append(recomendation(text: "Уменьшите количество продуктов, содержащих углеводы."))
            }
        }
        if temp.isEmpty {
            temp.append(recomendation(text: "Вероятно, уровень глюкозы после еды будет высоким, рекомендована прогулка после приема пищи."))
        }
    }
    return temp
}

func checkUnequalGlDistribution(listOfFood: [foodItem]) -> Bool {
    var temp = listOfFood
    temp = temp.sorted(by: {$0.gl > $1.gl})
    let totalGL = temp.map{$0.gl}.reduce(0, +)
    let partialGL = Array(temp[0..<temp.count/2]).map{$0.gl}.reduce(0, +)
    if partialGL / totalGL >= 0.6 {
        return true
    }
    return false
}

func checkBGPredicted(BG1: Double) -> Bool {
    if BG1 > 6.8 {
        return true
    } else {
        return false
    }
}

func checkGI(listOfFood: [foodItem]) -> Bool {
    return listOfFood.contains(where: {$0.gi >= 55})
}

func checkCarbo(foodType: String, listOfFood: [foodItem]) -> (Bool, Bool) {
    let sum = listOfFood.map{$0.carbo}.reduce(0, +)
    if foodType == "Завтрак" && sum > 15 {
        if sum > 30 {
            return (true, true)
        } else {
            return (true, false)
        }
    } else if foodType != "" && sum > 30 {
        if sum > 60 {
            return (true, true)
        } else {
            return (true, false)
        }
    }
    return (false, false)
}

func checkBGBefore(BG0: Double) -> Bool {
    if BG0 > 6.8 {
        return true
    } else {
        return false
    }
}

func checkPV(listOfFood: [foodItem], date: Date) -> Bool {
    var lowPV = false
    do {
        var sum = 0.0
        var sumToday = 0.0
        var sumYest = 0.0
        var listOfPV: [Double] = []
        
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        
        let food = Table("food")
        let id = Expression<String>("_id")
        let pv = Expression<Double?>("pv")
        for i in listOfFood {
            for i1 in try db.prepare(food.select(pv).filter(id == "\(i.table_id)")){
                listOfPV.append((i1[pv] ?? 0.0)*(i.gram ?? 0.0)/100)
            }
        }
        sum = listOfPV.reduce(0,+)
        listOfPV.removeAll()
        
        let diary = Table("diary")
        let id_food = Expression<Int>("id_food")
        let _date = Expression<String>("date")
        let g = Expression<String>("g")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        for i in try db.prepare(diary.select(id_food, g).filter(_date == dateFormatter.string(from: date))){
            for i1 in try db.prepare(food.select(pv).filter(id == "\(i[id_food])")){
                listOfPV.append((i1[pv] ?? 0.0)*(Double(i[g]) ?? 0.0)/100)
            }
        }
        sumToday = listOfPV.reduce(0,+)
        listOfPV.removeAll()
        
        let yest = date.addingTimeInterval(-60*60*24)
        for i in try db.prepare(diary.select(id_food, g).filter(_date == dateFormatter.string(from: yest))){
            for i1 in try db.prepare(food.select(pv).filter(id == "\(i[id_food])")){
                listOfPV.append((i1[pv] ?? 0.0)*(Double(i[g]) ?? 0.0)/100)
            }
        }
        sumYest = listOfPV.reduce(0,+)
        listOfPV.removeAll()
        
        if sum < 8 {
            lowPV = true
        } else if sum + sumToday < 20 {
            lowPV = true
        } else if sum + sumYest < 28 {
            lowPV = true
        }
    }
    catch {
        print(error)
    }
    return lowPV
}
