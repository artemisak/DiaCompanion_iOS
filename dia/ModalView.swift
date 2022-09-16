import SwiftUI
import PDFKit

struct ModalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var fileUrl = Bundle.main.url(forResource: "Education", withExtension: "pdf")!
    @State private var phelper : Bool = false
    @State private var eraseAccount = false
    @State private var eraseDB = false
    @State private var eraseDBprogress = false
    @State private var arrowAngle = 0.0
    @ObservedObject var islogin: check
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("О пациенте").font(.system(size: 15.5))){
                    NavigationLink(destination: ketonur(t: "", date: Date(), idForDelete: [], hasChanged: .constant(false), txtTheme: $txtTheme)) {
                        Button("Добавить запись о кетонурии", action: {})
                    }.foregroundColor(.black)
                    NavigationLink(destination: massa(t: "", date: Date(), idForDelete: [], hasChanged: .constant(false), txtTheme: $txtTheme)) {
                        Button("Измерение массы тела", action: {})
                    }.foregroundColor(.black)
                    NavigationLink(destination: pacientPage()) {
                        Button("Данные пациента", action: {})
                    }.foregroundColor(.black)
                    NavigationLink(destination: poldny(txtTheme: $txtTheme)) {
                        Button("Отметить полные дни", action: {})
                    }.foregroundColor(.black)
                    NavigationLink(destination: PDFKitView(url: fileUrl).ignoresSafeArea(.all, edges: .bottom).navigationTitle("Обучение").navigationBarTitleDisplayMode(.inline)) {
                        Button("Обучение", action: {})
                    }.foregroundColor(.black)
                    NavigationLink(destination: helper(phelper: $phelper)) {
                        Button("Помощь", action: {})
                    }.foregroundColor(.black)
                }
                Section(header: Text("Параметры восстановления").font(.system(size: 15.5))){
                    Button {
                        eraseDB = true
                    } label: {
                        HStack{
                            if eraseDBprogress {
                                ProgressView().frame(width: 22.5)
                            } else {
                                Image(systemName: "arrow.clockwise").frame(width: 22.5)
                            }
                            Text("Восстановить базу данных").padding(.leading)
                            Spacer()
                        }.foregroundColor(Color.accentColor)
                    }
                    .confirmationDialog("Восстановление подразумевает отмену всех вносимых в вами в базу данных имзенений.", isPresented: $eraseDB, titleVisibility: .visible, actions: {
                        Button("ОК", action: {
                            eraseDBprogress = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {eraseDBprogress = restoreDB()})
                        })
                    })
                }
                Section(header: Text("Управление аккаунтом").font(.system(size: 15.5))) {
                    Button(action: {
                        eraseAccount = true
                    }, label: {
                        HStack{
                            Image(systemName: "trash.fill")
                            Text("Удалить аккаунт").padding(.leading)
                            Spacer()
                        }.foregroundColor(Color.red)
                    }).confirmationDialog("Удаляя аккаунт вы потеряете доступ к приложению, вся информация в нем будет удалена.", isPresented: $eraseAccount, titleVisibility: .visible, actions: {
                        Button("ОК", action: {
                            dismiss()
                            withAnimation() {
                                islogin.istrue = false
                            }
                            Task {
                                await deleteAccaunt()
                            }
                        })
                    })
                }
            }
            .listStyle(.insetGrouped)
            .ignoresSafeArea(.keyboard)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Дополнительно")
        }
        .navigationViewStyle(.stack)
    }
}

struct pacientPage: View {
    @State private var pFio: Bool = false
    @State private var pV: Bool = false
    @State private var pDate: Bool = false
    @State private var bStart: Bool = false
    @State private var bWeek: Bool = false
    @State private var bid: Bool = false
    @State private var bWeight: Bool = false
    @State private var bHeight: Bool = false
    @State private var txt: String = ""
    @State private var vDate = Date()
    var body: some View {
        ZStack {
            List {
                Section(header: Text("Данные пациента").font(.system(size: 15.5))){
                    Button(action: {withAnimation(.default){pFio.toggle()}}) {
                        Text("ФИО")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation(.default){pDate.toggle()}}) {
                        Text("Дата рождения")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation(.default){pV.toggle()}}) {
                        Text("Лечащий врач")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation(.default){bStart.toggle()}}) {
                        Text("Дата начала ведения дневника")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation(.default){bWeek.toggle()}}) {
                        Text("Неделя берем. на начало исследования")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation(.default){bid.toggle()}}) {
                        Text("Индивидуальный номер пациента")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation(.default){bWeight.toggle()}}) {
                        Text("Вес до беременности, кг")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation(.default){bHeight.toggle()}}) {
                        Text("Рост до беременности, см")
                    }.foregroundColor(.black)
                }
            }
            .ignoresSafeArea(.keyboard)
            .listStyle(.insetGrouped)
            if bWeek {
                weekS(bWeek: $bWeek)
            }
            if pV {
                currentV(pV:$pV)
            }
            if pFio {
                fio(pFio: $pFio, txt: $txt)
            }
            if pDate {
                bday(pDate: $pDate, vDate: $vDate)
            }
            if bStart {
                dStart(bStart: $bStart, vDate: $vDate)
            }
            if bid {
                pid(bid: $bid, txt: $txt)
            }
            if bWeight {
                pWeight(bWeight: $bWeight, txt: $txt)
            }
            if bHeight {
                pHeight(bHeight: $bHeight, txt: $txt)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Персональная карта")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button(action: {
                    UIApplication.shared.dismissedKeyboard()
                }, label: {
                    Text("Готово")
                })
            })
        }
    }
}
