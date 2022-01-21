//
//  test.swift
//  dia
//
//  Created by Артем  on 08.12.2021.
//
import Foundation
import xlsxwriter

class Anatomy {
    func generate() async throws -> URL {
        
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent("foodTable.xlsx")
        
        let workbook = workbook_new((fileURL.absoluteString.dropFirst(6) as NSString).fileSystemRepresentation)
        let worksheet1 = workbook_add_worksheet(workbook, "Приемы пищи")
        worksheet_set_column(worksheet1, 0, 0, 20, nil)
        let merge_format = workbook_add_format(workbook);
        format_set_align(merge_format, UInt8(LXW_ALIGN_CENTER.rawValue));
        format_set_align(merge_format, UInt8(LXW_ALIGN_VERTICAL_CENTER.rawValue));
        
        let tbl = getFoodRecords()
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yyyy"
        let formater1 = DateFormatter()
        formater1.dateFormat = "HH:mm"
                
        var listOfIndex: [Int] = []
        for i in 0..<tbl.count {
            listOfIndex.append(tbl[i].food.joined().count)
        }
        var listOfIndex1: [Int] = []
        for i in 0..<tbl.count {
            for i1 in 0..<tbl[i].foodType.count{
                listOfIndex1.append(tbl[i].food[i1].count)
            }
        }
  
        var d = 0
        var r = 0
        var r1 = 0
        var rr = 0
        
        for i in 0..<tbl.count {
            worksheet_merge_range(worksheet1, lxw_row_t(listOfIndex[0..<i+1].reduce(0,+)-listOfIndex[i]), 0, lxw_row_t(listOfIndex[0..<i+1].reduce(0,+)-1), 0, nil, nil);
            worksheet_write_string(worksheet1, lxw_row_t(d), 0, formater.string(from: tbl[i].day), merge_format)
            d = d + tbl[i].food.joined().count
            for i1 in 0..<tbl[i].time.count {
                worksheet_merge_range(worksheet1, lxw_row_t(r1), 1, lxw_row_t(r1+listOfIndex1[rr]-1), 1, nil, nil);
                worksheet_write_string(worksheet1, lxw_row_t(r1), 1, formater1.string(from: tbl[i].time[i1]), merge_format)
                worksheet_merge_range(worksheet1, lxw_row_t(r1), 2, lxw_row_t(r1+listOfIndex1[rr]-1), 2, nil, nil);
                worksheet_write_string(worksheet1, lxw_row_t(r1), 2, tbl[i].foodType[i1], merge_format)
                r1 = r1 + tbl[i].food[i1].count
                rr += 1
            }
            for j in 0..<tbl[i].food.joined().count {
                worksheet_write_string(worksheet1, lxw_row_t(r), 3, Array(tbl[i].food.joined())[j], nil)
                worksheet_write_string(worksheet1, lxw_row_t(r), 4, Array(tbl[i].g.joined())[j], nil)
                worksheet_write_string(worksheet1, lxw_row_t(r), 5, Array(tbl[i].carbo.joined())[j], nil)
                worksheet_write_string(worksheet1, lxw_row_t(r), 6, Array(tbl[i].prot.joined())[j], nil)
                worksheet_write_string(worksheet1, lxw_row_t(r), 7, Array(tbl[i].fat.joined())[j], nil)
                worksheet_write_string(worksheet1, lxw_row_t(r), 8, Array(tbl[i].ec.joined())[j], nil)
                worksheet_write_string(worksheet1, lxw_row_t(r), 9, Array(tbl[i].gi.joined())[j], nil)
                worksheet_write_string(worksheet1, lxw_row_t(r), 10, Array(tbl[i].empty.joined())[j], nil)
                worksheet_write_string(worksheet1, lxw_row_t(r), 11, Array(tbl[i].water.joined())[j], nil)
                r += 1
            }
        }
        
//        worksheet_protect(worksheet1, "pass123", nil)
        let error = workbook_close(workbook)
        
        if (error.rawValue != LXW_NO_ERROR.rawValue){
            print("Error in workbook_close().\nError %d = %s\n", error, lxw_strerror(error)!)
        }
        return fileURL
    }
}
