//
//  login.swift
//  dia
//
//  Created by Артём Исаков on 12.02.2022.
//

import SwiftUI

struct login: View {
    @State private var login: String = ""
    @State private var pass: String = ""
    @State private var istrue = false
    @StateObject var islogin = check()
    var body: some View {
        NavigationView {
            GeometryReader { g in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        NavigationLink(isActive: $istrue, destination: {mainPage()}, label:{ EmptyView()})
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Логин")
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            TextField("email@gmail.com", text: $login)
                                .font(.system(size: 20))
                                .padding(.top, 5)
                            Divider()
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Пароль")
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            SecureField("password", text: $pass)
                                .font(.system(size: 20))
                                .padding(.top, 5)
                            Divider()
                        }
                        .padding(.top, 20)
                        Button(action: {
                            istrue = true
                            Task {
                                await islogin.setlogged(upass: pass, ulogin: login)
                            }
                        }, label: {
                            Text("Войти")
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                        })
                            .padding(.top, 20)
                    }
                    .padding()
                    .frame(minHeight: g.size.height)
                }
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack{
                        Text("Dia ID")
                            .font(.title)
                            .fontWeight(.bold)
                        Image("ofIcon")
                            .resizable()
                            .frame(width: 35.0, height: 35.0)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .task {
            await islogin.checklog()
            istrue = islogin.login

        }
    }
}

struct login_Previews: PreviewProvider {
    static var previews: some View {
        login()
    }
}
