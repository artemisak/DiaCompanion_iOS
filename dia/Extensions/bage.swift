//
//  unitsBage.swift
//  dia
//
//  Created by Артём Исаков on 09.11.2023.
//

import SwiftUI

struct bage: View {
    var txt: String
    var body: some View {
        Text(LocalizedStringKey(txt)).padding(.vertical, 8).padding(.horizontal, 12).background(content: {RoundedRectangle(cornerRadius: 8).fill(Color("Sep"))})
    }
}
