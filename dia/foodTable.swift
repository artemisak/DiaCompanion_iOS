//
//  test.swift
//  dia
//
//  Created by Артем  on 08.12.2021.
//
import Foundation
import xlsxwriter

class Anatomy{
    func generate() async throws -> URL {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent("foodTable.xlsx")
        
        //Create a new workbook.
        //Ditch first 6 characters, because they are of the form file://
        let workbook = workbook_new((fileURL.absoluteString.dropFirst(6) as NSString).fileSystemRepresentation)
        //Add a worksheet with a user defined sheet name.
        let worksheet1 = workbook_add_worksheet(workbook, "Приемы пищи")
        //Widen the first column to make the text clearer.
        worksheet_set_column(worksheet1, 0, 0, 20, nil)
        let merge_format = workbook_add_format(workbook);
        format_set_align(merge_format, UInt8(LXW_ALIGN_CENTER.rawValue));
        format_set_align(merge_format, UInt8(LXW_ALIGN_VERTICAL_CENTER.rawValue));
        
        //Write some unformatted data.
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
        
        print(listOfIndex)
        print(listOfIndex1)
        for i in 0..<tbl.count {
            worksheet_merge_range(worksheet1, lxw_row_t(listOfIndex[0..<i+1].reduce(0,+)-listOfIndex[i]), 0, lxw_row_t(listOfIndex[0..<i+1].reduce(0,+)-1), 0, nil, nil);
            worksheet_write_string(worksheet1, lxw_row_t(d), 0, formater.string(from: tbl[i].day), merge_format)
            d = d + tbl[i].food.joined().count
            for i1 in 0..<tbl[i].time.count {
                worksheet_write_string(worksheet1, lxw_row_t(r1), 1, formater1.string(from: tbl[i].time[i1]), nil)
                worksheet_write_string(worksheet1, lxw_row_t(r1), 2, tbl[i].foodType[i1], nil)
                r1 = r1 + tbl[i].food[i1].count
            }
            for j in 0..<tbl[i].food.joined().count {
                worksheet_write_string(worksheet1, lxw_row_t(r), 3, Array(tbl[i].food.joined())[j], nil)
                worksheet_write_string(worksheet1, lxw_row_t(r), 4, Array(tbl[i].g.joined())[j], nil)
                r += 1
            }
        }

        //Close the workbook, save the file and free any memory.
        let error = workbook_close(workbook)
        //Check if there was any error creating the xlsx file.
        if (error.rawValue != LXW_NO_ERROR.rawValue){
            print("Error in workbook_close().\nError %d = %s\n", error, lxw_strerror(error)!)
        }
        return fileURL
    }
}
