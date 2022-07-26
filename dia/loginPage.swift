import SwiftUI

enum Field: Hashable {
    case username
    case password
}

struct loginPage: View {
    @State private var login: String = ""
    @State private var pass: String = ""
    @State private var isWrong: Bool = true
    @State private var isnt: Bool = false
    @State private var reg: Bool = false
    @Binding var txtTheme: DynamicTypeSize
    @FocusState private var focusedField: Field?
    @StateObject private var islogin = check()

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.dismissedKeyboard()
                    }
                VStack(spacing: 0) {
                    NavigationLink(isActive: $isnt, destination: {mainPage(txtTheme: $txtTheme, isnt: $isnt)}, label: {EmptyView()})
                        .hidden()
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Логин")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.bottom, 5)
                            .onTapGesture {
                                UIApplication.shared.dismissedKeyboard()
                            }
                        TextField("example@mail.ru", text: $login)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .username)
                            .onSubmit {
                                focusedField = .password
                            }
                        Divider()
                            .background(!isWrong ? Color.red : Color.black)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Пароль")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.bottom, 5)
                        SecureField("password", text: $pass)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .password)
                            .onSubmit {
                                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                    isnt = islogin.setlogged(upass: pass, ulogin: login)
                                    isWrong = isnt
                                })
                                if !isnt {
                                    focusedField = .username
                                }
                            }
                        Divider()
                            .background(!isWrong ? Color.red : Color.black)
                    }
                    .padding(.top, 22.5)
                    if !isWrong {
                        Color.clear
                            .frame(height: 30)
                            .padding(.bottom, 10)
                            .background(
                                Text("Неверный логин или пароль")
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .onTapGesture {
                                        UIApplication.shared.dismissedKeyboard()
                                    }
                            )
                    } else {
                        Color.clear
                            .frame(height: 30)
                    }
                    Button(action: {
                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                            isnt = islogin.setlogged(upass: pass, ulogin: login)
                            isWrong = isnt
                        })
                        if !isnt {
                            focusedField = .username
                        }
                    }, label: {
                        Text("Войти")
                    })
                    .buttonStyle(RoundedRectangleButtonStyle())
                    Button {
                        withAnimation(){
                            reg = true
                        }
                    } label: {
                        HStack{
                            Text("Регистрация")
                            Image(systemName: "questionmark.circle")
                        }
                    }
                    .buttonStyle(ChangeColorButton())
                    .padding(.top, 10)
                }
                .padding()
                .frame(maxHeight: .infinity)
                .ignoresSafeArea()
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
                            UIApplication.shared.dismissedKeyboard()
                        }, label: {
                            Text("Готово").dynamicTypeSize(txtTheme)
                        })
                    })
                }
            }
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        .customPopupView(isPresented: $reg, popupView: { regHelper(phelper: $reg) })
        .task {
            login = ""
            pass = ""
            islogin.checklog()
            isnt = islogin.istrue
        }
    }
}
