//
//  loginPage.swift
//  dia
//
//  Created by Артём Исаков on 11.11.2022.
//
import SwiftUI

enum Field: Hashable {
    case username
    case password
}

struct loginPage: View {
    @State private var login: String = ""
    @State private var pass: String = ""
    @State private var isnt: Bool = true
    @State private var reg: Bool = false
    @State private var isLoading: Bool = false
    @Binding var txtTheme: DynamicTypeSize
    @FocusState private var focusedField: Field?
    @EnvironmentObject var islogin: check
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: .zero) {
                    TextField("Логин", text: $login)
                        .onChange(of: login, perform: {i in
                            if !isnt {
                                withAnimation(.default){
                                    isnt.toggle()
                                }
                            }
                        })
                        .foregroundColor(.black)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .username)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(isnt ? Color.gray.opacity(0.5) : Color.red, lineWidth: 1))
                .onTapGesture {
                    focusedField = .username
                }
                VStack(alignment: .leading, spacing: .zero) {
                    SecureField("Пароль", text: $pass)
                        .onChange(of: pass, perform: {i in
                            if !isnt {
                                withAnimation(.default){
                                    isnt.toggle()
                                }
                            }
                        })
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .password)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(isnt ? Color.gray.opacity(0.5) : Color.red, lineWidth: 1))
                .onTapGesture {
                    focusedField = .password
                }
            }
            if !isnt {
                Text("Неверный логин или пароль")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button(action: {
                if login.isEmpty {
                    focusedField = .username
                } else if pass.isEmpty {
                    focusedField = .password
                } else {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                        isLoading = false
                        withAnimation(.default){
                            isnt = islogin.setlogged(upass: pass, ulogin: login)
                        }
                    })
                }
            }, label: {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(focusedField == .username ? "Далее" : "Войти")
                }
            })
            .buttonStyle(RoundedRectangleButtonStyle())
            NavigationLink(destination: {
                regHelper(phelper: $reg)
            }, label: {
                HStack{
                    Text("Регистрация")
                    Image(systemName: "questionmark.circle")
                }
            })
            .buttonStyle(ChangeColorButton())
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Dia ID")
                        .foregroundColor(Color.black)
                        .font(.title)
                        .fontWeight(.bold)
                        .fixedSize()
                    Image("ofIconTransparent")
                        .resizable()
                        .frame(width: 35.0, height: 35.0)
                        .zIndex(1)
                }
            }
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button(action: {
                    focusedField = nil
                }, label: {
                    Text("Готово").dynamicTypeSize(txtTheme)
                })
            })
        }
        .onAppear {
            login = ""
            pass = ""
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
