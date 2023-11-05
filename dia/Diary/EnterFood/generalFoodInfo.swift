//
//  generalFoodInfo.swift
//  dia
//
//  Created by Артём Исаков on 02.11.2023.
//

import SwiftUI

struct generalFoodInfo: View {
    @Binding var previewIndex: ftype
    @Binding var date: Date
    var body: some View {
        NavigationLink(destination: ftPicker(ftpreviewIndex: $previewIndex), label: {
            HStack {
                Text("Прием пищи")
                Spacer()
                Text(LocalizedStringKey(previewIndex.rawValue))
            }
        })
        DatePicker(
            "Дата",
            selection: $date,
            displayedComponents: [.date, .hourAndMinute]
        ).datePickerStyle(.compact)
    }
}
