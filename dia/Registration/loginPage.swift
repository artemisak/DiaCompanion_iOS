//
//  loginPage.swift
//  dia
//
//  Created by Артём Исаков on 11.11.2022.
//
import SwiftUI
import AVFoundation

struct loginPage: View {
    @State private var login: String = ""
    @State private var isValidLogin: Bool = true
    @State private var nextField: Bool = false
    @State private var isLoading: Bool = false
    @Binding var txtTheme: DynamicTypeSize
    @FocusState private var focusedField: Bool
    @EnvironmentObject var loginManager: Router
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: .zero) {
                    TextField("Логин", text: $login)
                        .onChange(of: login, perform: {i in
                            if !isValidLogin {
                                withAnimation(.default){
                                    isValidLogin.toggle()
                                }
                            }
                        })
                        .foregroundColor(.black)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focusedField)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(isValidLogin ? Color.gray.opacity(0.5) : Color.red, lineWidth: 1))
                .onTapGesture {
                    focusedField = true
                }
            }
            if !isValidLogin {
                Text("Такого аккаунта не существует")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if #available(iOS 16, *){
                Button(action: {
                    if login.isEmpty {
                        withAnimation(.default){
                            focusedField = true
                        }
                    } else {
                        withAnimation(.default){
                            isValidLogin = loginManager.checkEnteredLogin(login)
                            if isValidLogin {
                                focusedField = false
                            }
                        }
                    }
                }, label: {
                    Text("Далее").frame(height: 25)
                })
                .buttonStyle(RoundedRectangleButtonStyle())
            } else {
                Button {
                    if login.isEmpty {
                        withAnimation(.default){
                            focusedField = true
                        }
                    } else {
                        withAnimation(.default){
                            isValidLogin = loginManager.checkEnteredLogin(login)
                            if isValidLogin {
                                focusedField = false
                                nextField = true
                            }
                        }
                    }
                } label: {
                    Text("Далее").frame(height: 25)
                }
                .buttonStyle(RoundedRectangleButtonStyle())
                NavigationLink(isActive: $nextField, destination: {passwordPage(txtTheme: $txtTheme)}, label: {EmptyView()})
                    .buttonStyle(TransparentButton()).isHidden(true)
            }
            if #available(iOS 16, *){
                Button {
                    focusedField = false
                    loginManager.navigateToHelper()
                } label: {
                    HStack{
                        Text("Регистрация")
                        Image(systemName: "questionmark.circle")
                    }
                }
                .buttonStyle(ChangeColorButton())
            } else {
                NavigationLink(destination: {
                    regHelper()
                }, label: {
                    HStack{
                        Text("Регистрация")
                        Image(systemName: "questionmark.circle")
                    }
                })
                .buttonStyle(ChangeColorButton())
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
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
        }
        .animation(.default, value: focusedField)
    }
}
