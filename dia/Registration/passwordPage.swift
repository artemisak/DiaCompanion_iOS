//
//  passwordPage.swift
//  dia
//
//  Created by Артём Исаков on 14.11.2022.
//

import SwiftUI

struct passwordPage: View {
    @State private var pass: String = ""
    @State private var isValidPassword: Bool = true
    @State private var nextField: Bool = false
    @State private var isLoading: Bool = false
    @Binding var txtTheme: DynamicTypeSize
    @FocusState private var focusedField: Bool
    @EnvironmentObject var loginManager: Router
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: .zero) {
                    SecureField("Пароль", text: $pass)
                        .onChange(of: pass, perform: {i in
                            if !isValidPassword {
                                withAnimation(.default){
                                    isValidPassword.toggle()
                                }
                            }
                        })
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focusedField)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(isValidPassword ? Color.gray.opacity(0.5) : Color.red, lineWidth: 1))
                .onTapGesture {
                    focusedField = true
                }
            }
            if !isValidPassword {
                Text("Неверный пароль")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
            if #available(iOS 16, *){
                Button(action: {
                    if pass.isEmpty {
                        withAnimation(.default){
                            focusedField = true
                        }
                    }
                    else {
                        withAnimation(.default){
                            isValidPassword = loginManager.checkEnteredPassord(pass)
                        }
                        if isValidPassword {
                            isLoading = true
                            Task {
                                await loginManager.setLogged()
                                isLoading = false
                            }
                        }
                        
                    }
                }, label: {
                    if isLoading {
                        ProgressView().tint(.white).frame(height: 25)
                    } else {
                        Text("Войти").frame(height: 25)
                    }
                })
                .buttonStyle(RoundedRectangleButtonStyle())
            } else {
                Button(action: {
                    if pass.isEmpty {
                        withAnimation(.default){
                            focusedField = true
                        }
                    }
                    else {
                        withAnimation(.default){
                            isValidPassword = loginManager.checkEnteredPassord(pass)
                        }
                        if isValidPassword {
                            isLoading = true
                            Task {
                                await loginManager.setLogged()
                                isLoading = false
                                nextField = true
                            }
                        }
                    }
                }, label: {
                    if isLoading {
                        ProgressView().tint(.white).frame(height: 25)
                    } else {
                        Text("Войти").frame(height: 25)
                    }
                })
                .buttonStyle(RoundedRectangleButtonStyle())
                NavigationLink(isActive: $nextField, destination: {versionChoose()}, label: {EmptyView()})
                    .buttonStyle(TransparentButton()).isHidden(true)
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
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
    }
}
