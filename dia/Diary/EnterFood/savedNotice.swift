//
//  savedNotice.swift
//  dia
//
//  Created by Артём Исаков on 11.08.2022.
//

import SwiftUI

struct savedNotice: View {
    var body: some View {
        VStack(spacing: .zero){
            Spacer()
            HStack {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
                Text("Данные успешно сохранены").foregroundColor(.blue)
            }
            .padding()
            .background(
                Color(red: 232/255, green: 242/255, blue: 254/255).cornerRadius(20)
                    .shadow(radius: 2.5)
            )
            Spacer()
                .frame(height: UIScreen.main.bounds.height/8)
        }
    }
}
