//
//  ModalView.swift
//  dia
//
//  Created by Артем  on 19.08.2021.
//

import SwiftUI

struct ModalView: View {
    @Binding var isShowing: Bool
    @State private var curHeight: CGFloat = 330
    var body: some View {
        ZStack(alignment: .bottom){
            if isShowing{
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
                mainView
                .transition(.move(edge: .bottom))
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut)
    }
    var mainView: some View {
        VStack{
            ZStack{
                List{
                    Button("Добавить запись о кетонурии", action: {print("1")})
                    Button("Добавить измерение массы тела", action: {print("2")})
                    Button("Данные пациента", action: {print("3")})
                    Button("Обучение", action: {print("4")})
                    Button("Помощь", action: {print("5")})
                }
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.white)
                            .frame(height: curHeight + 45)
                    )
                Button(action: {isShowing = false}){
                    Text("Отменить")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.blue)
                    )
                    .foregroundColor(.white)
                    .frame(width: 355)
                    .frame(height: 50)
                    .offset(y: 110)
            }
        }
            .frame(height: curHeight)
            .frame(maxWidth: .infinity)
            
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(isShowing: .constant(true))
    }
}


