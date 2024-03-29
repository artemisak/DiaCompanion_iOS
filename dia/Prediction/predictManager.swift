//
//  predictManager.swift
//  dia
//
//  Created by Артём Исаков on 08.05.2022.
//

import Foundation
import CoreML
import SQLite

enum modelErorrs: Error {
    case generalError
}

struct inpData {
    var meal_type_n: Double
    var gi: Double
    var gl: Double
    var carbo: Double
    var mds: Double
    var kr: Double
    var ca: Double
    var fe: Double
    var carbo_b6h: Double
    var prot_b6h: Double
    var fat_b6h: Double
    var pv_b12h: Double
    var BG: Double
    var BMI: Double
    var HbA1C_V1: Double
    var TG_V1: Double
    var Hol_V1: Double
    var weight: Double
    var age: Double
    var fasting_glu: Double
    var pregnancy_week: Double
}

class predictManager {
    
    static let provider = predictManager()
    
    func getPredict(meal_type_n: Double, gi: Double, gl: Double, carbo: Double, carbo_b6h: Double, prot_b6h: Double, fat_b6h: Double, BG: Double, BMI: Double, HbA1C_V1: Double, TG_V1: Double, Hol_V1: Double, fasting_glu: Double, pregnancy_week: Double) throws -> Double {
        let model = try hyperglycemiaPredictor(configuration: MLModelConfiguration())
        guard let output = try? model.prediction(input: hyperglycemiaPredictorInput(f0: meal_type_n, f1: gi, f2: gl, f3: carbo, f4: carbo_b6h, f5: prot_b6h, f6: fat_b6h, f7: BG, f8: BMI, f9: HbA1C_V1, f10: TG_V1, f11: Hol_V1, f12: fasting_glu, f13: pregnancy_week)) else {
            fatalError("Failed to make prediction")
        }
        let target = output.classProbability[1]!
        return target
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
            let fat = Expression<Double>("fat")
            let kr = Expression<Double?>("kr")
            let mds = Expression<Double?>("mds")
            let ca = Expression<Double?>("ca")
            let fe = Expression<Double?>("fe")
            let pv = Expression<Double?>("pv")
            
            let diary = Table("diary")
            let food = Expression<String>("foodName")
            let date = Expression<Date>("dateTime")
            let g = Expression<String>("g")
            
            let userT = Table("usermac")
            let w = Expression<Double?>("weight")
            let h = Expression<Double?>("height")
            let birthday = Expression<String?>("birthday")
            
            let questionaryT = Table("questionary")
            let hemoglobin = Expression<Double?>("HbA1C")
            let cholesterol = Expression<Double?>("cholesterol")
            let triglycerides = Expression<Double?>("triglycerides")
            let fasting_glu = Expression<Double?>("glucose")
            let week = Expression<Double?>("preg_week")
            
            var nutr = [[Double]]()
            try zip(foodN,gram).forEach {
                for i in try db.prepare(foodT.where(name == $0).select(gi,carbo,mds,kr,ca,fe)) {
                    nutr.append([i[gi]*(i[carbo]*$1/100.0), (i[carbo]*$1/100.0)*i[gi]/100.0, i[carbo]*$1/100.0, (i[mds] ?? 0.0)*$1/100.0, (i[kr] ?? 0.0)*$1/100.0, (i[ca] ?? 0.0)*$1/100.0, (i[fe] ?? 0.0)*$1/100.0])
                }
            }
            
            var sum_of_nutr = [Double]()
            for i in 0..<nutr[0].count {
                var column = 0.0
                for j in 0..<nutr.count {
                    column += nutr[j][i]
                }
                sum_of_nutr.append(column)
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd-MM-yyyy"
            
            let previousFormat = SQLite.dateFormatter.dateFormat
            SQLite.dateFormatter = formatter
            
            let temps = formatter.string(from: picker_date)
            let tempd = formatter.date(from: temps)!
            
            var foodb6h = [[String]]()
            for i in try db.prepare(diary.filter((date > tempd.addingTimeInterval(-60*60*6)) & (date < tempd)).select(food, g)){
                foodb6h.append([i[food], i[g]])
            }
            
            var foodb12h = [[String]]()
            for i in try db.prepare(diary.filter((date > tempd.addingTimeInterval(-60*60*12)) & (date < tempd)).select(food, g)){
                foodb12h.append([i[food], i[g]])
            }
            
            SQLite.dateFormatter.dateFormat = previousFormat
            
            var protb6h: Double = 0.0
            try foodb6h.forEach {
                for i in try db.prepare(foodT.where(name == $0[0]).select(prot)){
                    protb6h += i[prot] * (Double($0[1]) ?? 100.0) / 100
                }
            }
            
            var carbob6h: Double = 0.0
            try foodb6h.forEach {
                for i in try db.prepare(foodT.where(name == $0[0]).select(carbo)){
                    carbob6h += i[carbo] * (Double($0[1]) ?? 100.0) / 100
                }
            }
            
            var fatb6h: Double = 0.0
            try foodb6h.forEach{
                for i in try db.prepare(foodT.where(name == $0[0]).select(fat)){
                    fatb6h += i[fat] * (Double($0[1]) ?? 100.0) / 100
                }
            }
            
            var pvb12h: Double = 0.0
            try foodb12h.forEach{
                for i in try db.prepare(foodT.where(name == $0[0]).select(pv)){
                    pvb12h += (i[pv] ?? 0.0) * (Double($0[1]) ?? 100.0) / 100
                }
            }
            
            var weight: Double = 0.0
            var height: Double = 0.0
            var BMI: Double = 0.0
            var birth: Date = Date.now
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            for i in try db.prepare(userT.select(w, h, birthday)){
                weight = i[w] ?? 0.0
                height = i[h] ?? 0.0
                birth = dateFormatter.date(from: i[birthday]!)!
            }
            if weight != 0.0 && height != 0.0 {
                BMI = weight/pow(height/100, 2.0)
            }
            let calendar = Calendar.current
            let age = Double(calendar.dateComponents([.year], from: birth, to: Date.now).year!)
            
            var hem: Double = 0.0
            var chol: Double = 0.0
            var trigl: Double = 0.0
            var glu: Double = 0.0
            var preg_week: Double = 0.0
            for i in try db.prepare(questionaryT.select(hemoglobin, cholesterol, triglycerides, fasting_glu, week)){
                hem = i[hemoglobin] ?? 0.0
                chol = i[cholesterol] ?? 0.0
                trigl = i[triglycerides] ?? 0.0
                glu = i[fasting_glu] ?? 0.0
                preg_week = i[week] ?? 0.0
            }
            
            var food_type_n: Double =  0.0
            switch foodtype {
            case .zavtrak:
                food_type_n = 1.0
            case .obed:
                food_type_n = 2.0
            case .uzin:
                food_type_n = 3.0
            case .perekus:
                food_type_n = 4.0
            }
            
            let BG = BG0
            
            return inpData(meal_type_n: food_type_n, gi: sum_of_nutr[0]/sum_of_nutr[2], gl: sum_of_nutr[1], carbo: sum_of_nutr[2], mds: sum_of_nutr[3], kr: sum_of_nutr[4], ca: sum_of_nutr[5], fe: sum_of_nutr[6], carbo_b6h: carbob6h, prot_b6h: protb6h, fat_b6h: fatb6h, pv_b12h: pvb12h, BG: BG, BMI: BMI, HbA1C_V1: hem, TG_V1: trigl, Hol_V1: chol, weight: weight, age: age, fasting_glu: glu, pregnancy_week: preg_week)
        }
        catch {
            print(error)
            return inpData(meal_type_n: 0.0, gi: 0.0, gl: 0.0, carbo: 0.0, mds: 0.0, kr: 0.0, ca: 0.0, fe: 0.0, carbo_b6h: 0.0, prot_b6h: 0.0, fat_b6h: 0.0, pv_b12h: 0.0, BG: 0.0, BMI: 0.0, HbA1C_V1: 0.0, TG_V1: 0.0, Hol_V1: 0.0, weight: 0.0, age: 0.0, fasting_glu: 0.0, pregnancy_week: 0.0)
        }
    }
    
}
