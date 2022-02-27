//
//  login.swift
//  dia
//
//  Created by Артём Исаков on 12.02.2022.
//

import SwiftUI
import UIKit

struct loginPage: View {
    @State private var login: String = ""
    @State private var pass: String = ""
    @State private var isWrong: Bool = true
    @ObservedObject var islogin: check
    var body: some View {
        VStack(spacing: 0) {
            Color.white
                .frame(height: 30)
                .onTapGesture {
                    UIApplication.shared.dismissedKeyboard()
                }
            VStack(alignment: .leading, spacing: 8) {
                Text("Логин")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                TextField("Email", text: $login)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .font(.system(size: 20))
                    .padding(.top, 5)
                if !isWrong {
                    Divider()
                        .background(Color.red)
                    
                } else {
                    Divider()
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Пароль")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                SecureField("Password", text: $pass)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .font(.system(size: 20))
                    .padding(.top, 5)
                if !isWrong {
                    Divider()
                        .background(Color.red)
                    
                } else {
                    Divider()
                }
            }
            .padding(.top, 20)
            if !isWrong {
                Color.white
                    .frame(height: 30)
                    .onTapGesture {
                        UIApplication.shared.dismissedKeyboard()
                    }
                    .overlay(
                        Text("Неверный логин или пароль").foregroundColor(.red).font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    )
            } else {
                Color.white
                    .frame(height: 30)
                    .onTapGesture {
                        UIApplication.shared.dismissedKeyboard()
                    }
            }
            Button(action: {
                withAnimation {
                    UIApplication.shared.dismissedKeyboard()
                    isWrong = islogin.setlogged(upass: pass, ulogin: login)
                }
            }, label: {
                Text("Войти")
            })
                .buttonStyle(RoundedRectangleButtonStyle())
        }
        .padding()
        .frame(maxHeight: .infinity)
        .gesture(
            DragGesture(minimumDistance: 0.1, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.height < 0 {
                        UIApplication.shared.dismissedKeyboard()
                    }
                    if value.translation.height > 0 {
                        UIApplication.shared.dismissedKeyboard()
                    }
                }
        )
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack{
                    Text("Dia ID")
                        .foregroundColor(Color.black)
                        .font(.title)
                        .fontWeight(.bold)
                    Image("ofIcon")
                        .resizable()
                        .frame(width: 35.0, height: 35.0)
                }
            }
        }
    }
}

struct RoundedRectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label.foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(Color.blue.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

extension UIApplication {
    func dismissedKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
