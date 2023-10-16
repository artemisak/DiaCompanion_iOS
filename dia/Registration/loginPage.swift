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
    @State private var pass: String = ""
    @State private var isValid: Bool = true
    @State private var isLoading: Bool = false
    @State private var nextField: Bool = false
    @EnvironmentObject var routeManager: Router
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: .zero) {
                    TextField("", text: $login, prompt: Text("Логин").font(.body))
                        .labelsHidden()
                        .onChange(of: login, perform: {i in
                            if !isValid {
                                withAnimation(.default){
                                    isValid.toggle()
                                }
                            }
                        })
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(isValid ? Color("buttonStroke") : Color("buttonStrokeAlert"), lineWidth: 1))
            }
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: .zero) {
                    SecureField("", text: $pass, prompt: Text("Пароль").font(.body))
                        .labelsHidden()
                        .onChange(of: pass, perform: {i in
                            if !isValid {
                                withAnimation(.default){
                                    isValid.toggle()
                                }
                            }
                        })
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(isValid ? Color.gray.opacity(0.5) : Color.red, lineWidth: 1))
            }
            if !isValid {
                Text("Проверьте правильность введенных данных или повторите попытку позже")
                    .font(.caption)
                    .foregroundColor(Color("buttonStrokeAlert"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button(action: {
                if pass.isEmpty || login.isEmpty {
                    isValid = false
                }
                else {
                    isLoading = true
                    Task {
                        await routeManager.authorization(login: login, password: pass) { authorized in
                            isValid = authorized
                            Task {
                                if isValid {
                                    await routeManager.setLogged()
                                    DispatchQueue.main.async {
                                        isLoading = false
                                        nextField = true
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        isLoading = false
                                        nextField = false
                                    }
                                }
                            }
                        }
                    }
                }
            }, label: {
                if isLoading {
                    ProgressView().tint(.white).frame(height: 25)
                } else {
                    Text("Войти").font(.body).frame(height: 25)
                }
            })
            .buttonStyle(RoundedRectangleButtonStyle())
            NavigationLink(destination: {
                regHelper()
            }, label: {
                HStack{
                    Text("Регистрация").font(.body)
                    Image(systemName: "questionmark.circle")
                }
            })
            .buttonStyle(ChangeColorButton())
            NavigationLink(isActive: $nextField, destination: {versionChoose()}, label: {EmptyView()})
                .buttonStyle(TransparentButton()).hidden()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Dia ID")
                        .foregroundColor(Color("listButtonColor"))
                        .font(.title)
                        .fontWeight(.bold)
                        .fixedSize()
                    Image("ofIconTransparent")
                        .resizable()
                        .frame(width: 36.0, height: 36.0)
                        .zIndex(1)
                }
            }
        }
        .animation(.default, value: isLoading)
        .animation(.default, value: isValid)
    }
}
