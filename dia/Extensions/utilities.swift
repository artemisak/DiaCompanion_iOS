//
//  utilities.swift
//  dia
//
//  Created by Артём Исаков on 30.01.2023.
//

import Foundation

func convert(txt: String) throws -> Double {
    let decimal = txt.components(separatedBy:",")
    guard decimal.count-1 < 2 else {
        throw inputErorrs.decimalError
    }
    guard !txt.isEmpty else {
        throw inputErorrs.EmptyError
    }
    guard (Double(String(txt.map{ $0 == "," ? "." : $0})) != nil) else {
        throw inputErorrs.UndefinedError
    }
    return Double(String(txt.map{ $0 == "," ? "." : $0}))!
}

func convertToInt(txt: String) throws -> Int {
    guard !txt.isEmpty else {
        throw inputErorrs.EmptyError
    }
    guard (Int(txt) != nil) else {
        throw inputErorrs.UndefinedError
    }
    return Int(txt)!
}

func copyDatabaseIfNeeded(sourcePath: String) -> Bool {
    let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let destinationPath = documents + "/diacompanion.db"
    let exists = FileManager.default.fileExists(atPath: destinationPath)
    guard !exists else { return false }
    do {
        try FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)
        return true
    } catch {
        print("error during file copy: \(error)")
        return false
    }
}

func copyBackDatabaseIfNeeded(sourcePath: String) -> Bool {
    let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let destinationPath = documents + "/reserved.db"
    let exists = FileManager.default.fileExists(atPath: destinationPath)
    guard !exists else { return false }
    do {
        try FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)
        return true
    } catch {
        print("error during file copy: \(error)")
        return false
    }
}
