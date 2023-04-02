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
    @FocusState private var focusedField: Bool
    @EnvironmentObject var routeManager: Router
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: .zero) {
                    TextField("", text: $login, prompt: Text("almazov@mail.ru").font(.body))
                        .labelsHidden()
                        .onChange(of: login, perform: {i in
                            if !isValidLogin {
                                withAnimation(.default){
                                    isValidLogin.toggle()
                                }
                            }
                        })
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focusedField)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(isValidLogin ? Color("buttonStroke") : Color("buttonStrokeAlert"), lineWidth: 1))
                .onTapGesture {
                    focusedField = true
                }
            }
            if !isValidLogin {
                Text("Такого аккаунта не существует")
                    .font(.caption)
                    .foregroundColor(Color("buttonStrokeAlert"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button {
                if login.isEmpty {
                    withAnimation(.default){
                        focusedField = true
                    }
                } else {
                    withAnimation(.default){
                        isValidLogin = routeManager.checkEnteredLogin(login)
                        if isValidLogin {
                            focusedField = false
                            nextField = true
                        }
                    }
                }
            } label: {
                Text("Далее").font(.body).frame(height: 25)
            }
            .buttonStyle(RoundedRectangleButtonStyle())
            NavigationLink(isActive: $nextField, destination: {passwordPage()}, label: {EmptyView()})
                .buttonStyle(TransparentButton()).hidden()
            NavigationLink(destination: {
                regHelper()
            }, label: {
                HStack{
                    Text("Регистрация").font(.body)
                    Image(systemName: "questionmark.circle")
                }
            })
            .buttonStyle(ChangeColorButton())
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
        .animation(.default, value: focusedField)
    }
}
