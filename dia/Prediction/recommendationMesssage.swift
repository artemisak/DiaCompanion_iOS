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

func getMessage(BGPredicted: Double, BGBefore: Double, carboAbove15: Bool, moderateAmountOfCarbo: Bool, tooManyCarbo: Bool, twiceAsMach: Bool, unequalGLDistribution: Bool, highGI: Bool) -> ([recomendation], String, Double) {
    var temp  = [recomendation]()
    var msg = ""
    var correctedBG = BGPredicted
    
    if BGBefore >= 6.7 {
        temp.append(recomendation(text: "Высокий уровень глюкозы до еды. Рекомендовано уменьшить количество углеводов во время перекусов. Возможно, требуется назначение малых доз инсулина. Проконсультируйтесь с врачом."))
    }
    
    if twiceAsMach {
        temp.append(recomendation(text: "Количество углеводов более, чем в два раза, превышает рекомендованное при ГСД. Уменьшите количество углеводсодержащих продуктов."))
    }

    if BGPredicted >= 0.4 {
        if (moderateAmountOfCarbo && unequalGLDistribution) {
            temp.append(recomendation(text: "Уменьшите количество продуктов с высокой гликемической нагрузкой (ГН)."))
        } else if (moderateAmountOfCarbo && highGI) {
            temp.append(recomendation(text: "Рекомендуется исключить из рациона или уменьшить количество продуктов с высоким гликемическим индексом (более 55)."))
        } else if (moderateAmountOfCarbo && tooManyCarbo) {
            temp.append(recomendation(text: "Уменьшите количество продуктов, содержащих углеводы."))
        } else {
            temp.append(recomendation(text: "Вероятно, уровень глюкозы после еды будет высоким, рекомендована прогулка после приема пищи."))
        }
        msg = "превысит"
    } else {
        if (!temp.isEmpty && carboAbove15) {
            if unequalGLDistribution {
                temp.append(recomendation(text: "Уменьшите количество продуктов с высокой гликемической нагрузкой (ГН)."))
            } else if highGI {
                temp.append(recomendation(text: "Рекомендуется исключить из рациона или уменьшить количество продуктов с высоким гликемическим индексом (более 55)."))
            } else if tooManyCarbo {
                temp.append(recomendation(text: "Уменьшите количество продуктов, содержащих углеводы."))
            } else {
                temp.append(recomendation(text: "Вероятно, уровень глюкозы после еды будет высоким, рекомендована прогулка после приема пищи."))
            }
            msg = "превысит"
            correctedBG += (1-BGPredicted)*0.5
        } else {
            msg = "не превысит"
        }
    }
    
    return (temp, msg, correctedBG)
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

func checkGI(listOfFood: [foodItem]) -> Bool {
    return listOfFood.contains(where: {$0.gi >= 55})
}

func checkCarbo(foodType: String, listOfFood: [foodItem], date: Date) -> (Bool, Bool, Bool, Bool) {
    let df = DateFormatter()
    df.dateFormat = "HH:mm"
    let shortendDate = df.date(from: df.string(from: date))!
    let sum = listOfFood.map{$0.weightedСarbo}.reduce(0, +)
    let above15 = sum >= 15
    if (shortendDate <= df.date(from: "11:00")!) && (sum > 15) {
        if sum > 30 {
            if sum > 90 {
                return (above15, true, true, true)
            } else {
                return (above15, true, true, false)
            }
        } else {
            return (above15, true, false, false)
        }
    } else if (shortendDate > df.date(from: "11:00")!) && (sum > 30) {
        if sum > 60 {
            if sum > 120 {
                return (above15, true, true, true)
            } else {
                return (above15, true, true, false)
            }
        } else {
            return (above15, true, false, false)
        }
    }
    return (above15, false, false, false)
}
