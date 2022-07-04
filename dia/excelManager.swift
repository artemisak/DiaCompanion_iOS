import Foundation
import SQLite

struct FoodRecord {
    var day: Date
    var time: Date
    var foodType: String
    var food:  [String]
    var g: [String]
    var carbo: [String]
    var prot: [String]
    var fat: [String]
    var ec: [String]
    var gi: [String]
    var empty: [String]
    var water: [String]
    var nzhk: [String]
    var hol: [String]
    var pv: [String]
    var zola: [String]
    var na: [String]
    var k: [String]
    var ca: [String]
    var mg: [String]
    var p: [String]
    var fe: [String]
    var a: [String]
    var b1: [String]
    var b2: [String]
    var rr: [String]
    var c: [String]
    var re: [String]
    var kar: [String]
    var mds: [String]
    var kr: [String]
    var te: [String]
    var ok: [String]
    var ne: [String]
}

struct TableRecord {
    var day: Date
    var time: [Date]
    var foodType: [String]
    var food:  [[String]]
    var g: [[String]]
    var carbo: [[String]]
    var prot: [[String]]
    var fat: [[String]]
    var ec: [[String]]
    var gi: [[String]]
    var empty: [[String]]
    var water: [[String]]
    var nzhk: [[String]]
    var hol: [[String]]
    var pv: [[String]]
    var zola: [[String]]
    var na: [[String]]
    var k: [[String]]
    var ca: [[String]]
    var mg: [[String]]
    var p: [[String]]
    var fe: [[String]]
    var a: [[String]]
    var b1: [[String]]
    var b2: [[String]]
    var rr: [[String]]
    var c: [[String]]
    var re: [[String]]
    var kar: [[String]]
    var mds: [[String]]
    var kr: [[String]]
    var te: [[String]]
    var ok: [[String]]
    var ne: [[String]]
}

func getFoodRecords() -> [TableRecord] {
    var record = [FoodRecord]()
    var table = [TableRecord]()
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let foodTable = Table("diary")
        let day = Expression<String>("date")
        let time = Expression<String>("time")
        let foodType = Expression<String>("foodType")
        let foodName = Expression<String>("foodName")
        let gram = Expression<String>("g")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale(identifier: "ru_RU")
        dateFormatter1.setLocalizedDateFormatFromTemplate("HH:mm")
        
        let foodInfo = Table("food")
        let foodN = Expression<String>("name")
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
        
        for i in try db.prepare(foodTable.select(day,time,foodType,foodName,gram)){
            record.append(FoodRecord(day: dateFormatter.date(from: i[day])!, time: dateFormatter1.date(from: i[time])!,foodType: i[foodType], food: [i[foodName]], g: [i[gram]], carbo: [""], prot: [""], fat: [""], ec: [""], gi: [""], empty: [""], water: [""], nzhk: [""], hol: [""], pv: [""], zola: [""], na: [""], k: [""], ca: [""], mg: [""], p: [""], fe: [""], a:[""], b1: [""], b2: [""], rr: [""], c: [""], re: [""], kar: [""], mds: [""], kr: [""], te: [""], ok: [""], ne: [""]))
        }
        
        for i in 0..<record.count {
            for i1 in try db.prepare(foodInfo.select(foodN, carbo, prot, fat, ec, gi, water, nzhk, hol, pv, zola, na, k, ca, mg, p, fe, a, b1, b2, rr, c, re, kar, mds, kr, te, ok, ne).filter(foodN == record[i].food[0])){
                record[i].carbo = ["\(i1[carbo] ?? 0.0)"]
                record[i].prot = ["\(i1[prot] ?? 0.0)"]
                record[i].fat = ["\(i1[fat] ?? 0.0)"]
                record[i].ec = ["\(i1[ec] ?? 0.0)"]
                record[i].gi = ["\(i1[gi] ?? 0.0)"]
                record[i].water = ["\(i1[water] ?? 0.0)"]
                record[i].nzhk = ["\(i1[nzhk] ?? 0.0)"]
                record[i].hol = ["\(i1[hol] ?? 0.0)"]
                record[i].pv = ["\(i1[pv] ?? 0.0)"]
                record[i].zola = ["\(i1[zola] ?? 0.0)"]
                record[i].na = ["\(i1[na] ?? 0.0)"]
                record[i].k = ["\(i1[k] ?? 0.0)"]
                record[i].ca = ["\(i1[ca] ?? 0.0)"]
                record[i].mg = ["\(i1[mg] ?? 0.0)"]
                record[i].p = ["\(i1[p] ?? 0.0)"]
                record[i].fe = ["\(i1[fe] ?? 0.0)"]
                record[i].a = ["\(i1[a] ?? 0.0)"]
                record[i].b1 = ["\(i1[b1] ?? 0.0)"]
                record[i].b2 = ["\(i1[b2] ?? 0.0)"]
                record[i].rr = ["\(i1[rr] ?? 0.0)"]
                record[i].c = ["\(i1[c] ?? 0.0)"]
                record[i].re = ["\(i1[re] ?? 0.0)"]
                record[i].kar = ["\(i1[kar] ?? 0.0)"]
                record[i].mds = ["\(i1[mds] ?? 0.0)"]
                record[i].kr = ["\(i1[kr] ?? 0.0)"]
                record[i].te = ["\(i1[te] ?? 0.0)"]
                record[i].ok = ["\(i1[ok] ?? 0.0)"]
                record[i].ne = ["\(i1[ne] ?? 0.0)"]
            }
        }
        
        if record.count > 0 {
            record = record.sorted(by: {($0.day, $0.time, $0.foodType) < ($1.day, $1.time, $1.foodType)})
            
            var i = 1
            while i < record.count {
                if record[i].day == record[i-1].day && record[i].time == record[i-1].time && record[i].foodType == record[i-1].foodType {
                    record[i].food = record[i-1].food + record[i].food
                    record[i].g = record[i-1].g + record[i].g
                    record[i].carbo = record[i-1].carbo + record[i].carbo
                    record[i].prot = record[i-1].prot + record[i].prot
                    record[i].fat = record[i-1].fat + record[i].fat
                    record[i].ec = record[i-1].ec + record[i].ec
                    record[i].gi = record[i-1].gi + record[i].gi
                    record[i].empty = record[i-1].empty + record[i].empty
                    record[i].water = record[i-1].water + record[i].water
                    record[i].nzhk = record[i-1].nzhk + record[i].nzhk
                    record[i].hol = record[i-1].hol + record[i].hol
                    record[i].pv = record[i-1].pv + record[i].pv
                    record[i].zola = record[i-1].zola + record[i].zola
                    record[i].na = record[i-1].na + record[i].na
                    record[i].k = record[i-1].k + record[i].k
                    record[i].ca = record[i-1].ca + record[i].ca
                    record[i].mg = record[i-1].mg + record[i].mg
                    record[i].p = record[i-1].p + record[i].p
                    record[i].fe = record[i-1].fe + record[i].fe
                    record[i].a = record[i-1].a + record[i].a
                    record[i].b1 = record[i-1].b1 + record[i].b1
                    record[i].b2 = record[i-1].b2 + record[i].b2
                    record[i].rr = record[i-1].rr + record[i].rr
                    record[i].c = record[i-1].c + record[i].c
                    record[i].re = record[i-1].re + record[i].re
                    record[i].kar = record[i-1].kar + record[i].kar
                    record[i].mds = record[i-1].mds + record[i].mds
                    record[i].kr = record[i-1].kr + record[i].kr
                    record[i].te = record[i-1].te + record[i].te
                    record[i].ok = record[i-1].ok + record[i].ok
                    record[i].ne = record[i-1].ne + record[i].ne
                    record.remove(at: i-1)
                } else {
                    i += 1
                }
            }
            
            table.append(TableRecord(day: record[0].day, time: [record[0].time], foodType: [record[0].foodType], food: [record[0].food], g: [record[0].g], carbo: [record[0].carbo], prot: [record[0].prot], fat: [record[0].fat], ec: [record[0].ec], gi: [record[0].gi], empty: [record[0].empty], water: [record[0].water], nzhk: [record[0].nzhk], hol: [record[0].hol], pv: [record[0].pv], zola: [record[0].zola], na: [record[0].na], k: [record[0].k], ca: [record[0].ca], mg: [record[0].mg], p: [record[0].p], fe: [record[0].fe], a: [record[0].a], b1: [record[0].b1], b2: [record[0].b2], rr: [record[0].rr], c: [record[0].c], re: [record[0].re], kar: [record[0].kar], mds: [record[0].mds], kr: [record[0].kr], te: [record[0].te], ok: [record[0].ok], ne: [record[0].ne]))
            record.remove(at: 0)
            
            while (record.count>0) {
                if record[0].day == table[table.endIndex-1].day {
                    table[table.endIndex-1].time.append(record[0].time)
                    table[table.endIndex-1].foodType.append(record[0].foodType)
                    table[table.endIndex-1].food.append(record[0].food)
                    table[table.endIndex-1].g.append(record[0].g)
                    table[table.endIndex-1].carbo.append(record[0].carbo)
                    table[table.endIndex-1].prot.append(record[0].prot)
                    table[table.endIndex-1].fat.append(record[0].fat)
                    table[table.endIndex-1].ec.append(record[0].ec)
                    table[table.endIndex-1].gi.append(record[0].gi)
                    table[table.endIndex-1].empty.append(record[0].empty)
                    table[table.endIndex-1].water.append(record[0].water)
                    table[table.endIndex-1].nzhk.append(record[0].nzhk)
                    table[table.endIndex-1].hol.append(record[0].hol)
                    table[table.endIndex-1].pv.append(record[0].pv)
                    table[table.endIndex-1].zola.append(record[0].zola)
                    table[table.endIndex-1].na.append(record[0].na)
                    table[table.endIndex-1].k.append(record[0].k)
                    table[table.endIndex-1].ca.append(record[0].ca)
                    table[table.endIndex-1].mg.append(record[0].mg)
                    table[table.endIndex-1].p.append(record[0].p)
                    table[table.endIndex-1].fe.append(record[0].fe)
                    table[table.endIndex-1].a.append(record[0].a)
                    table[table.endIndex-1].b1.append(record[0].b1)
                    table[table.endIndex-1].b2.append(record[0].b2)
                    table[table.endIndex-1].rr.append(record[0].rr)
                    table[table.endIndex-1].c.append(record[0].c)
                    table[table.endIndex-1].re.append(record[0].re)
                    table[table.endIndex-1].kar.append(record[0].kar)
                    table[table.endIndex-1].mds.append(record[0].mds)
                    table[table.endIndex-1].kr.append(record[0].kr)
                    table[table.endIndex-1].te.append(record[0].te)
                    table[table.endIndex-1].ok.append(record[0].ok)
                    table[table.endIndex-1].ne.append(record[0].ne)
                    record.remove(at: 0)
                } else {
                    table.append(TableRecord(day: record[0].day, time:[record[0].time], foodType: [record[0].foodType], food:[record[0].food], g:[record[0].g], carbo: [record[0].carbo], prot: [record[0].prot], fat: [record[0].fat], ec: [record[0].ec], gi: [record[0].gi], empty: [record[0].empty], water: [record[0].water], nzhk: [record[0].nzhk], hol: [record[0].hol], pv: [record[0].pv], zola: [record[0].zola], na: [record[0].na], k: [record[0].k], ca: [record[0].ca], mg: [record[0].mg], p: [record[0].p], fe: [record[0].fe], a: [record[0].a], b1: [record[0].b1], b2: [record[0].b2], rr: [record[0].rr], c: [record[0].c], re: [record[0].re], kar: [record[0].kar], mds: [record[0].mds], kr: [record[0].kr], te: [record[0].te], ok: [record[0].ok], ne: [record[0].ne]))
                    record.remove(at: 0)
                }
            }
            
        }
    }
    catch {
        print(error)
    }
    return table
}

func getName() -> String {
    var fio: String = ""
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let foodTable = Table("usermac")
        let userName = Expression<String?>("fio")
        for i in try db.prepare(foodTable.select(userName)){
            if i[userName] != nil {
                fio = i[userName]!
            } else {
                fio = "Новый пользователь 1"
            }
        }
        if fio == "" {
            fio = "Новый пользователь 1"
        }
    }
    catch {
        print(error)
    }
    return fio
}

struct sugarlvl {
    var date: String
    var natoshak: [[String]]
    var zavtrak: [[String]]
    var obed: [[String]]
    var yzin: [[String]]
    var dop: [[String]]
    var rodi: [[String]]
}

struct injectlvl {
    var date: String
    var natoshak: [String]
    var zavtrak: [String]
    var obed: [String]
    var uzin: [String]
    var dop: [String]
    var levemir: [String]
}

struct recordRow {
    var date: Date
    var time: Date
    var lvl: Double
    var period: String
}

struct injectRow {
    var date: Date
    var time: Date
    var ed: Double
    var type: String
    var priem: String
}

func getSugarRecords() -> [sugarlvl] {
    
    var sugarRecords = [sugarlvl]()
    var record = [recordRow]()
    var tableInjetcs = [injectlvl]()
    var injRecord = [injectRow]()
    
    do {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/diacompanion.db"
        let sourcePath = Bundle.main.path(forResource: "diacompanion", ofType: "db")!
        _=copyDatabaseIfNeeded(sourcePath: sourcePath)
        let db = try Connection(path)
        let sugarChange = Table("sugarChange")
        let lvl = Expression<Double>("lvl")
        let period = Expression<String>("period")
        let time = Expression<String>("time")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale(identifier: "ru_RU")
        dateFormatter1.setLocalizedDateFormatFromTemplate("HH:mm")
        
        for i in try db.prepare(sugarChange.select(lvl,period,time)) {
            record.append(recordRow(date: dateFormatter.date(from: i[time][6..<16])! , time: dateFormatter1.date(from: i[time][0..<5])!, lvl: i[lvl], period: i[period]))
        }
        record = record.sorted(by: {($0.date, $0.time) < ($1.date, $1.time)})
        
        var sugarUniqueDates = [Date]()
        for i in record {
            sugarUniqueDates.append(i.date)
        }
        sugarUniqueDates = Array(Set(sugarUniqueDates))
        sugarUniqueDates = sugarUniqueDates.sorted(by: <)
        
        let injects = Table("inject")
        let injectID = Expression<Int>("id")
        let injectED = Expression<Double>("ed")
        let injectType = Expression<String>("type")
        let injectPriem = Expression<String>("priem")
        let injectTime = Expression<String>("time")
        
        for i in try db.prepare(injects.select(injectID, injectED, injectType, injectPriem, injectTime)){
            injRecord.append(injectRow(date: dateFormatter.date(from: i[time][6..<16])!, time: dateFormatter1.date(from: i[time][0..<5])!, ed: i[injectED], type: i[injectType], priem: i[injectPriem]))
        }
        injRecord = injRecord.sorted(by: {($0.date, $0.time) < ($1.date, $1.time)})
        
        var injectUniqueDates = [Date]()
        for i in injRecord {
            injectUniqueDates.append(i.date)
        }
        injectUniqueDates = Array(Set(injectUniqueDates))
        injectUniqueDates = injectUniqueDates.sorted(by: <)
        
        var uniqueDates = [Date]()
        uniqueDates.append(contentsOf: sugarUniqueDates)
        uniqueDates.append(contentsOf: injectUniqueDates)
        uniqueDates = Array(Set(uniqueDates))
        uniqueDates = uniqueDates.sorted(by: { $0 < $1})

        var i = 0
        while i < uniqueDates.count-1 {
            if DateInterval(start: uniqueDates[i], end: uniqueDates[i+1]) > DateInterval(start: uniqueDates[i], duration: 60*60*24) {
                uniqueDates.insert(uniqueDates[i].addingTimeInterval(60*60*24), at: i+1)
                i += 1
            } else {
                i += 1
            }
        }
        
        for i in uniqueDates {
            sugarRecords.append(sugarlvl(date: dateFormatter.string(from: i), natoshak: [], zavtrak: [], obed: [], yzin: [], dop: [], rodi: []))
            tableInjetcs.append(injectlvl(date: dateFormatter.string(from: i), natoshak: [], zavtrak: [], obed: [], uzin: [], dop: [], levemir: []))
        }
        
        var i1 = 0
        var i2 = 0
        while i2 <= record.count-1 {
            if record[i2].date == dateFormatter.date(from: sugarRecords[i1].date) {
                if record[i2].period == "Натощак" {
                    sugarRecords[i1].natoshak.append([String(record[i2].lvl), dateFormatter1.string(from: record[i2].time)])
                }
                if record[i2].period == "После завтрака" {
                    sugarRecords[i1].zavtrak.append([String(record[i2].lvl), dateFormatter1.string(from: record[i2].time)])
                }
                if record[i2].period == "После обеда" {
                    sugarRecords[i1].obed.append([String(record[i2].lvl), dateFormatter1.string(from: record[i2].time)])
                }
                if record[i2].period == "После ужина" {
                    sugarRecords[i1].yzin.append([String(record[i2].lvl), dateFormatter1.string(from: record[i2].time)])
                }
                if record[i2].period == "Дополнительно" {
                    sugarRecords[i1].dop.append([String(record[i2].lvl), dateFormatter1.string(from: record[i2].time)])
                }
                if record[i2].period == "При родах" {
                    sugarRecords[i1].rodi.append([String(record[i2].lvl), dateFormatter1.string(from: record[i2].time)])
                }
                i2 += 1
            } else {
                i1 += 1
            }
        }
                
        var i3 = 0
        var i4 = 0
        while i3 <= injRecord.count-1 {
            if dateFormatter.string(from: injRecord[i3].date) == tableInjetcs[i4].date {
                if injRecord[i3].priem == "Натощак" {
                    tableInjetcs[i4].natoshak = [String(injRecord[i3].ed), injRecord[i3].type, dateFormatter1.string(from: injRecord[i3].time)]
                }
                if injRecord[i3].priem == "Завтрак" {
                    tableInjetcs[i4].zavtrak = [String(injRecord[i3].ed), injRecord[i3].type, dateFormatter1.string(from: injRecord[i3].time)]
                }
                if injRecord[i3].priem == "Обед" {
                    tableInjetcs[i4].obed = [String(injRecord[i3].ed), injRecord[i3].type, dateFormatter1.string(from: injRecord[i3].time)]
                }
                if injRecord[i3].priem == "Ужин" {
                    tableInjetcs[i4].uzin = [String(injRecord[i3].ed), injRecord[i3].type, dateFormatter1.string(from: injRecord[i3].time)]
                }
                if injRecord[i3].priem == "Дополнительно" {
                    tableInjetcs[i4].dop = [String(injRecord[i3].ed), injRecord[i3].type, dateFormatter1.string(from: injRecord[i3].time)]
                }
                i3 += 1
            } else {
                i4 += 1
            }
        }
        print(tableInjetcs)
        print(sugarRecords)
    }
    catch {
        print(error)
    }
    return sugarRecords
}
