//
//  succesNotify.swift
//  ДиаКомпаньон Beta
//
//  Created by Артём Исаков on 13.01.2023.
//

import SwiftUI

struct succesNotify: View {
    @State private var trimTo: Double = 0.0
    @State private var xOffset: Double = -20
    var body: some View {
        HStack {
            Spacer()
            Circle().trim(from: 0, to: trimTo).stroke(lineWidth: 1.5).background {
                Image(systemName: "checkmark").aspectRatio(contentMode: .fit).clipShape(Rectangle().offset(x: CGFloat(xOffset)))
            }.frame(width: 30, height: 30)
            HStack(spacing: 0){
                Text("Обьект успешно ")
                Text("сохранен").bold()
            }
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
        .background {
            RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 10.0)).foregroundColor(Color("succesNotifiyColor"))
        }
        .padding()
        .onAppear {
            Task{
                withAnimation(.default.delay(0.25)) {
                    trimTo = 1.0
                    xOffset = 0
                }
            }
        }
    }
}

struct succesNotify_Previews: PreviewProvider {
    static var previews: some View {
        succesNotify()
    }
}
