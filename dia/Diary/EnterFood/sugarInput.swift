//
//  sugarInput.swift
//  dia
//
//  Created by Артём Исаков on 02.11.2023.
//

import SwiftUI

struct sugarInput: View {
    @Binding var sugar: String
    var body: some View {
        HStack {
            TextField("5,0", text: $sugar)
                .keyboardType(.decimalPad)
            Spacer()
            Text("ммоль/л").padding(.vertical, 8).padding(.horizontal, 12).background(content: {RoundedRectangle(cornerRadius: 8).fill(Color("Sep"))})
        }
    }
}
