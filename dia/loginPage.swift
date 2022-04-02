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
    @State private var isnt: Bool = false
    @State private var reg: Bool = false
    @ObservedObject var islogin: check
    var body: some View {
        ZStack{
        VStack(spacing: 0) {
            NavigationLink(isActive: $isnt, destination: {mainPage()}, label: {EmptyView()})
            Color.clear
                .frame(height: 30)
                .onTapGesture {
                    UIApplication.shared.dismissedKeyboard()
                }
            VStack(alignment: .leading, spacing: 0) {
                Text("Логин")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .font(.system(size: 20))
                    .padding(.bottom, 5)
                TextField("example@mail.ru", text: $login)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .font(.system(size: 20))
                Divider()
                    .background(!isWrong ? Color.red : Color.black)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Пароль")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .font(.system(size: 20))
                    .padding(.bottom, 5)
                SecureField("password", text: $pass)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .font(.system(size: 20))
                Divider()
                    .background(!isWrong ? Color.red : Color.black)
            }
            .padding(.top, 22.5)
            if !isWrong {
                Color.clear
                    .frame(height: 30)
                    .padding(.bottom, 10)
                    .onTapGesture {
                        UIApplication.shared.dismissedKeyboard()
                    }
                    .background(
                        Text("Неверный логин или пароль").foregroundColor(.red).font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    )
            } else {
                Color.clear
                    .frame(height: 30)
                    .onTapGesture {
                        UIApplication.shared.dismissedKeyboard()
                    }
            }
            Button(action: {
                UIApplication.shared.dismissedKeyboard()
                Task(priority: .userInitiated) {
                    isnt = await islogin.setlogged(upass: pass, ulogin: login)
                    isWrong = isnt
                }
            }, label: {
                Text("Войти")
                    .font(.system(size: 20))
            })
            .buttonStyle(RoundedRectangleButtonStyle())
            Button {
                reg = true
            } label: {
                HStack{
                    Text("Регистрация")
                        .font(.system(size: 20))
                    Image(systemName: "questionmark.circle")
                }
            }
            .padding(.top, 10)
//            .alert(isPresented: $reg) {
//                Alert(title: Text("Регистрация"), message: Text("Для получения логина и пароля обратитесь в Национальный медицинский исследовательский центр имени В.А.Алмазова. Обратите внимание, что приложение находится в бета-тесте, некоторые функции могут быть недоступны или работать некорректно. Сейчас в бета-тесте принимает участие медицинский персонал центра."), dismissButton: .default(Text("ОК")))
//            }
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
        .navigationBarBackButtonHidden(true)
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
                        .zIndex(1)
                }
            }
            ToolbarItem(placement: .keyboard, content: {
                HStack{
                    Spacer()
                    Button(action: {
                        UIApplication.shared.dismissedKeyboard()
                    }, label: {
                        Text("Готово")
                    })
                }
            })
        }
            if reg {
                helper(phelper: $reg)
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
        .opacity(configuration.isPressed ? 0.75 : 1)
    }
}

extension UIApplication {
    func dismissedKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
