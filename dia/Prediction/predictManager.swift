//
//  predictManager.swift
//  dia
//
//  Created by Артём Исаков on 08.05.2022.
//

import Foundation
import SQLite
import SwiftUI
import CoreML

enum modelErorrs: Error {
    case generalError
}

struct inpData {
    var BG0: Double
    var gl: Double
    var carbo: Double
    var protb6h: Double
    var food_type1: Double
    var food_type2: Double
    var food_type3: Double
    var food_type4: Double
    var kr: Double
    var BMI: Double
}

func getPredict(BG0: Double, gl: Double, carbo: Double, prot: Double, t1: Double, t2: Double, t3: Double, t4: Double, kr: Double, BMI: Double) throws -> Double {
    let config = MLModelConfiguration()
    guard let bestModel = try? predictModel(configuration: config) else {
        throw modelErorrs.generalError
    }
    let res = try! bestModel.prediction(BG0: BG0, gl: gl, carbo: carbo, prot_b6h: prot, types_food_n_1: t1, types_food_n_2: t2, types_food_n_3: t3, types_food_n_4: t4, f: kr, f1: BMI)
    return res.target
}

func getData(BG0: Double, foodtype: ftype, foodN: [String], gram: [Double], picker_date: Date) ->  inpData {
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let foodT = Table("food")
        let name = Expression<String>("name")
        let gi = Expression<Double>("gi")
        let carbo = Expression<Double>("carbo")
        let prot = Expression<Double>("prot")
        let kr = Expression<Double?>("kr")
        let diary = Table("diary")
        let food = Expression<String>("foodName")
        let date = Expression<Date>("dateTime")
        let userT = Table("usermac")
        let w = Expression<Double?>("weight")
        let h = Expression<Double?>("height")

        var nutr: [[Double]] = []
        try zip(foodN,gram).forEach {
            for i in try db.prepare(foodT.where(name == $0).select(gi,carbo,kr)) {
                nutr.append([(i[carbo]*$1/100.0)*i[gi]/100, i[carbo]*$1/100.0, (i[kr] ?? 0.0)*$1/100.0])
            }
        }
        
        for i in 0..<nutr.count-1 {
            for i1 in 0..<nutr[0].count {
                nutr[0][i1] = nutr[0][i1] + nutr[i+1][i1]
            }
        }
        
        var foodb6h : [String] = []
        for i in try db.prepare(diary.filter(picker_date.addingTimeInterval(-60*60*6)...picker_date ~= date).select(food)){
            foodb6h.append(i[food])
        }
        
        var protb6h: Double = 0.0
        try foodb6h.forEach{
            for i in try db.prepare(foodT.where(name == $0).select(prot)){
                protb6h += i[prot]
            }
        }
        nutr[0].append(protb6h)
        
        var weight = 0.0
        var height = 0.0
        for i in try db.prepare(userT.select(w, h)){
            if i[w] != nil {
                weight = i[w]!
            } else {
                weight = 60
            }
            if i[h] != nil {
                height = i[h]!
            } else {
                height = 165
            }
        }
        let BMI = weight/pow(height/100, 2.0)
        let nutrients: inpData
        switch foodtype {
        case .zavtrak:
            nutrients = inpData(BG0: BG0, gl: nutr[0][0], carbo: nutr[0][1], protb6h: nutr[0][3], food_type1: 1, food_type2: 0, food_type3: 0, food_type4: 0, kr: nutr[0][2], BMI: BMI)
        case .obed:
            nutrients = inpData(BG0: BG0, gl: nutr[0][0], carbo: nutr[0][1], protb6h: nutr[0][3], food_type1: 0, food_type2: 1, food_type3: 0, food_type4: 0, kr: nutr[0][2], BMI: BMI)
        case .uzin:
            nutrients = inpData(BG0: BG0, gl: nutr[0][0], carbo: nutr[0][1], protb6h: nutr[0][3], food_type1: 0, food_type2: 0, food_type3: 1, food_type4: 0, kr: nutr[0][2], BMI: BMI)
        case .perekus:
            nutrients = inpData(BG0: BG0, gl: nutr[0][0], carbo: nutr[0][1], protb6h: nutr[0][3], food_type1: 0, food_type2: 0, food_type3: 0, food_type4: 1, kr: nutr[0][2], BMI: BMI)
        }
        return nutrients
    }
    catch {
        print(error)
        return inpData(BG0: 0, gl: 0, carbo: 0, protb6h: 0, food_type1: 0, food_type2: 0, food_type3: 0, food_type4: 0, kr: 0, BMI: 0)
    }
}
