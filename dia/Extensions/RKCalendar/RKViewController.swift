//
//  RKViewController.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

struct RKViewController: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var rkManager: RKManager
    
    var body: some View {
        Group {
            List {
                ForEach(0..<numberOfMonths(), id: \.self) { index in
                    RKMonth(isPresented: self.$isPresented, rkManager: self.rkManager, monthOffset: index)
                }
            }
        }
    }
    
    func numberOfMonths() -> Int {
        return rkManager.calendar.dateComponents([.month], from: rkManager.minimumDate, to: rkManager.maximumDate).month! + 1
    }
    
    func RKMaximumDateMonthLastDay() -> Date {
        var components = rkManager.calendar.dateComponents([.year, .month, .day], from: rkManager.maximumDate)
        components.month! += 1
        components.day = 0
        
        return rkManager.calendar.date(from: components)!
    }
}
