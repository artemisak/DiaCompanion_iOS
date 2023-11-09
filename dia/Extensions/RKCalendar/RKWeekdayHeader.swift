//
//  RKWeekdayHeader.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

struct RKWeekdayHeader : View {
    
    var rkManager: RKManager
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(self.getWeekdayHeaders(calendar: self.rkManager.calendar), id: \.self) { weekday in
                Text(weekday)
                    .font(.caption)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(self.rkManager.colors.weekdayHeaderColor)
            }
        }.background(rkManager.colors.weekdayHeaderBackColor)
    }
    
    func getWeekdayHeaders(calendar: Calendar) -> [String] {
        
        let formatter = DateFormatter()
        var weekdaySymbols = formatter.shortStandaloneWeekdaySymbols
        let weekdaySymbolsCount = weekdaySymbols?.count ?? 0
        
        for _ in 0 ..< (1 - calendar.firstWeekday + weekdaySymbolsCount){
            let lastObject = weekdaySymbols?.last
            weekdaySymbols?.removeLast()
            weekdaySymbols?.insert(lastObject!, at: 0)
        }
        
        return weekdaySymbols ?? []
    }
}
