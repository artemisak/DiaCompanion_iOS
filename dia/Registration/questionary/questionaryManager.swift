//
//  questionaryManager.swift
//  dia
//
//  Created by Артём Исаков on 10.08.2023.
//

import Foundation
import SQLite

class questionaryManager {
    
    static let provider = questionaryManager()
    
    func saveGeneralQuestion(pregnancy_n: String, delivery_n: String, contraceptive: String, prolactin_test: String, heightened_prolactin: String, prolactin_drug_prescribed: String, prolactin_drug: String, vitamin_d_before: String, vitamin_d_before_drug: String, vitamin_d_after: String, vitamin_d_after_drug: String, weekendAtSouth: String, weekendAtSouth_firstTrimester: String, weekendAtSouth_secondTrimester: String, weekendAtSouth_thirdTrimester: String, solarium: String, HbA1C: String, triglycerides: String, cholesterol: String, glucose: String) async {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let questionaryT = Table("questionary")
            let fpregnancy_n = Expression<String>("pregnancy_n")
            let fdelivery_n = Expression<String>("delivery_n")
            let fcontraceptive = Expression<String>("contraceptive")
            let fprolactin_test = Expression<String>("prolactin_test")
            let fheightened_prolactin = Expression<String>("heightened_prolactin")
            let fprolactin_drug_prescribed = Expression<String>("prolactin_drug_prescribed")
            let fprolactin_drug = Expression<String>("prolactin_drug")
            let fvitamin_d_before = Expression<String>("vitamin_d_before")
            let fvitamin_d_before_drug = Expression<String>("vitamin_d_before_drug")
            let fvitamin_d_after = Expression<String>("vitamin_d_after")
            let fvitamin_d_after_drug = Expression<String>("vitamin_d_after_drug")
            let fweekendAtSouth = Expression<String>("weekendAtSouth")
            let fweekendAtSouth_firstTrimester = Expression<String>("weekendAtSouth_firstTrimester")
            let fweekendAtSouth_secondTrimester = Expression<String>("weekendAtSouth_secondTrimester")
            let fweekendAtSouth_thirdTrimester = Expression<String>("weekendAtSouth_thirdTrimester")
            let fsolarium = Expression<String>("solarium")
            let fHbA1C = Expression<String>("HbA1C")
            let ftriglycerides = Expression<String>("triglycerides")
            let fcholesterol = Expression<String>("cholesterol")
            let fglucose = Expression<String>("glucose")
            let all = Array(try db.prepare(questionaryT))
            if all.count != 0 {
                let update = questionaryT.update(fpregnancy_n <- pregnancy_n, fdelivery_n <- delivery_n, fcontraceptive <- contraceptive, fprolactin_test <- prolactin_test, fheightened_prolactin <- heightened_prolactin, fprolactin_drug_prescribed <- prolactin_drug_prescribed, fprolactin_drug <- prolactin_drug, fvitamin_d_before <- vitamin_d_before, fvitamin_d_before_drug <- vitamin_d_before_drug, fvitamin_d_after <- vitamin_d_after, fvitamin_d_after_drug <- vitamin_d_after_drug, fweekendAtSouth <- weekendAtSouth, fweekendAtSouth_firstTrimester <- weekendAtSouth_firstTrimester, fweekendAtSouth_secondTrimester <- weekendAtSouth_secondTrimester, fweekendAtSouth_thirdTrimester <- weekendAtSouth_thirdTrimester, fsolarium <- solarium , fHbA1C <- HbA1C, ftriglycerides <- triglycerides, fcholesterol <- cholesterol, fglucose <- glucose)
                try db.run(update)
            } else {
                let insert = questionaryT.insert(fpregnancy_n <- pregnancy_n, fdelivery_n <- delivery_n, fcontraceptive <- contraceptive, fprolactin_test <- prolactin_test, fheightened_prolactin <- heightened_prolactin, fprolactin_drug_prescribed <- prolactin_drug_prescribed, fprolactin_drug <- prolactin_drug, fvitamin_d_before <- vitamin_d_before, fvitamin_d_before_drug <- vitamin_d_before_drug, fvitamin_d_after <- vitamin_d_after, fvitamin_d_after_drug <- vitamin_d_after_drug, fweekendAtSouth <- weekendAtSouth, fweekendAtSouth_firstTrimester <- weekendAtSouth_firstTrimester, fweekendAtSouth_secondTrimester <- weekendAtSouth_secondTrimester, fweekendAtSouth_thirdTrimester <- weekendAtSouth_thirdTrimester, fsolarium <- solarium , fHbA1C <- HbA1C, ftriglycerides <- triglycerides, fcholesterol <- cholesterol, fglucose <- glucose)
                try db.run(insert)
            }
        } catch {
            print(error)
        }
    }
    
    func saveLifeStyle(family_diabetes: String, impaired_glucose_tolerance: String, hypertension_before: String, hypertension_after: String, smoking_before6month: String, smoking_before_known: String, smoking_after: String) async {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let questionaryT = Table("questionary")
            let ffamily_diabetes = Expression<String>("family_diabetes")
            let fimpaired_glucose_tolerance = Expression<String>("impaired_glucose_tolerance")
            let fhypertension_before = Expression<String>("hypertension_before")
            let fhypertension_after = Expression<String>("hypertension_after")
            let fsmoking_before6month = Expression<String>("smoking_before6month")
            let fsmoking_before_known = Expression<String>("smoking_before_known")
            let fsmoking_after = Expression<String>("smoking_after")
            let all = Array(try db.prepare(questionaryT))
            if all.count != 0 {
                let update = questionaryT.update(ffamily_diabetes <- family_diabetes, fimpaired_glucose_tolerance <- impaired_glucose_tolerance, fhypertension_before <- hypertension_before, fhypertension_after <- hypertension_after, fsmoking_before6month <- smoking_before6month, fsmoking_before_known <- smoking_before_known, fsmoking_after <- smoking_after)
                try db.run(update)
            } else {
                let insert = questionaryT.insert(ffamily_diabetes <- family_diabetes, fimpaired_glucose_tolerance <- impaired_glucose_tolerance, fhypertension_before <- hypertension_before, fhypertension_after <- hypertension_after, fsmoking_before6month <- smoking_before6month, fsmoking_before_known <- smoking_before_known, fsmoking_after <- smoking_after)
                try db.run(insert)
            }
        } catch {
            print(error)
        }
    }
    
    func saveFoodPrefrences(fruits_before: String, fruits_after: String, bisquits_before: String, bisquits_after: String, baking_before: String, baking_after: String, chocolate_before: String, chocolate_after: String, milk_before: String, milk_after: String, milk_before_alt: String, milk_after_alt: String, legumes_before: String, legumes_after: String, meat_before: String, meat_after: String, dried_fruits_before: String, dried_fruits_after: String, fish_before:String, fish_after: String, grain_bread_before: String, grain_bread_after: String, any_bread_before: String, any_bread_after: String, sauce_before: String, sauce_after: String, vegetable_before: String, vegetable_after: String, alcohol_before: String, alcohol_after: String, sweet_drinks_before: String, sweet_drinks_after: String, coffe_before: String, coffe_after: String, sausages_before: String, sausages_after: String) async {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let questionaryT = Table("questionary")
            let ffruits_before = Expression<String>("fruits_before")
            let ffruits_after = Expression<String>("fruits_after")
            let fbisquits_before = Expression<String>("bisquits_before")
            let fbisquits_after = Expression<String>("bisquits_after")
            let fbaking_before = Expression<String>("baking_before")
            let fbaking_after = Expression<String>("baking_after")
            let fchocolate_before = Expression<String>("chocolate_before")
            let fchocolate_after = Expression<String>("chocolate_after")
            let fmilk_before = Expression<String>("milk_before")
            let fmilk_after = Expression<String>("milk_after")
            let fmilk_before_alt = Expression<String>("milk_before_alt")
            let fmilk_after_alt = Expression<String>("milk_after_alt")
            let flegumes_before = Expression<String>("legumes_before")
            let flegumes_after = Expression<String>("legumes_after")
            let fmeat_before = Expression<String>("meat_before")
            let fmeat_after = Expression<String>("meat_after")
            let fdried_fruits_before = Expression<String>("dried_fruits_before")
            let fdried_fruits_after = Expression<String>("dried_fruits_after")
            let ffish_before = Expression<String>("fish_before")
            let ffish_after = Expression<String>("fish_after")
            let fgrain_bread_before = Expression<String>("grain_bread_before")
            let fgrain_bread_after = Expression<String>("grain_bread_after")
            let fany_bread_before = Expression<String>("any_bread_before")
            let fany_bread_after = Expression<String>("any_bread_after")
            let fsauce_before = Expression<String>("sauce_before")
            let fsauce_after = Expression<String>("sauce_after")
            let fvegetable_before = Expression<String>("vegetable_before")
            let fvegetable_after = Expression<String>("vegetable_after")
            let falcohol_before = Expression<String>("alcohol_before")
            let falcohol_after = Expression<String>("alcohol_after")
            let fsweet_drinks_before = Expression<String>("sweet_drinks_before")
            let fsweet_drinks_after = Expression<String>("sweet_drinks_after")
            let fcoffe_before = Expression<String>("coffe_before")
            let fcoffe_after = Expression<String>("coffe_after")
            let fsausages_before = Expression<String>("sausages_before")
            let fsausages_after = Expression<String>("sausages_after")
            let all = Array(try db.prepare(questionaryT))
            if all.count != 0 {
                let update = questionaryT.update(ffruits_before <- fruits_before, ffruits_after <- fruits_after, fbisquits_before <- bisquits_before, fbisquits_after <- bisquits_after, fbaking_before <- baking_before, fbaking_after <- baking_after, fchocolate_before <- chocolate_before, fchocolate_after <- chocolate_after, fmilk_before <- milk_before, fmilk_after <- milk_after, fmilk_before_alt <- milk_before_alt, fmilk_after_alt <- milk_after_alt, flegumes_before <- legumes_before, flegumes_after <- legumes_after, fmeat_before <- meat_before, fmeat_after <- meat_after, fdried_fruits_before <- dried_fruits_before, fdried_fruits_after <- dried_fruits_after, ffish_before <- fish_before, ffish_after <- fish_after, fgrain_bread_before <- grain_bread_before, fgrain_bread_after <- grain_bread_after, fany_bread_before <- any_bread_before, fany_bread_after <- any_bread_after, fsauce_before <- sauce_before, fsauce_after <- sauce_after, fvegetable_before <- vegetable_before, fvegetable_after <- vegetable_after, falcohol_before <- alcohol_before, falcohol_after <- alcohol_after, fsweet_drinks_before <- sweet_drinks_before, fsweet_drinks_after <- sweet_drinks_after, fcoffe_before <- coffe_before, fcoffe_after <- coffe_after, fsausages_before <- sausages_before, fsausages_after <- sausages_after)
                try db.run(update)
            } else {
                let insert = questionaryT.insert(ffruits_before <- fruits_before, ffruits_after <- fruits_after, fbisquits_before <- bisquits_before, fbisquits_after <- bisquits_after, fbaking_before <- baking_before, fbaking_after <- baking_after, fchocolate_before <- chocolate_before, fchocolate_after <- chocolate_after, fmilk_before <- milk_before, fmilk_after <- milk_after, fmilk_before_alt <- milk_before_alt, fmilk_after_alt <- milk_after_alt, flegumes_before <- legumes_before, flegumes_after <- legumes_after, fmeat_before <- meat_before, fmeat_after <- meat_after, fdried_fruits_before <- dried_fruits_before, fdried_fruits_after <- dried_fruits_after, ffish_before <- fish_before, ffish_after <- fish_after, fgrain_bread_before <- grain_bread_before, fgrain_bread_after <- grain_bread_after, fany_bread_before <- any_bread_before, fany_bread_after <- any_bread_after, fsausages_before <- sauce_before, fsauce_after <- sauce_after, fvegetable_before <- vegetable_before, fvegetable_after <- vegetable_after, falcohol_before <- alcohol_before, falcohol_after <- alcohol_after, fsweet_drinks_before <- sweet_drinks_before, fsweet_drinks_after <- sweet_drinks_after, fcoffe_before <- coffe_before, fcoffe_after <- coffe_after, fsausages_before <- sausages_before, fsausages_after <- sausages_after)
                try db.run(insert)
            }
        } catch {
            print(error)
        }
    }
    
    func saveActivityPrefrences(walkBefore: String, walkAfter: String, stepBefore: String, stepAfter: String, sportBefore: String, sportAfter: String) async {
        do {
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let path = documents + "/diacompanion.db"
            let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
            _=copyDatabaseIfNeeded(sourcePath: sourcePath)
            let db = try Connection(path)
            let questionaryT = Table("questionary")
            let fwalk_before = Expression<String>("walk_before")
            let fwalk_after = Expression<String>("walk_after")
            let fstep_before = Expression<String>("step_before")
            let fstep_after = Expression<String>("step_after")
            let fsport_before = Expression<String>("sport_before")
            let fsport_after = Expression<String>("sport_after")
            let all = Array(try db.prepare(questionaryT))
            if all.count != 0 {
                let update = questionaryT.update(fwalk_before <- walkBefore, fwalk_after <- walkAfter, fstep_before <- stepBefore, fstep_after <- stepAfter, fsport_before <- sportBefore, fsport_after <- sportAfter)
                try db.run(update)
            } else {
                let insert = questionaryT.insert(fwalk_before <- walkBefore, fwalk_after <- walkAfter, fstep_before <- stepBefore, fstep_after <- stepAfter, fsport_before <- sportBefore, fsport_after <- sportAfter)
                try db.run(insert)
            }
        } catch {
            print(error)
        }
    }
    
}
