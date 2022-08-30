import SwiftUI

enum Vrachi: String, CaseIterable, Identifiable {
    case Anopova = "Анопова Анна Дмитриевна"
    case Bolotko = "Болотько Яна Алексеевна"
    case Dronova = "Дронова Александра Владимировна"
    case Popova = "Попова Полина Викторовна"
    case Tkachuk = "Ткачут Александра Сергеевна"
    case Vasukova = "Васюкова Елена Андреева"
    case without = ""
    
    var id: String { self.rawValue }
}

struct currentV: View {
    @Binding var pV: Bool
    @State private var selectedVrach = Vrachi.Popova
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea()
            VStack(spacing:0){
                Text("Лечащий врач")
                    .padding()
                Divider()
                Picker("", selection: $selectedVrach) {
                    Text("Анопова Анна Дмитриевна").tag(Vrachi.Anopova)
                    Text("Болотько Яна Алексеевна").tag(Vrachi.Bolotko)
                    Text("Дронова Александра Владимировна").tag(Vrachi.Dronova)
                        .font(.system(size: 500))
                        .minimumScaleFactor(0.015)
                    Text("Попова Полина Викторовна").tag(Vrachi.Popova)
                    Text("Ткачук Александра Сергеевна").tag(Vrachi.Tkachuk)
                        .font(.system(size: 500))
                        .minimumScaleFactor(0.015)
                    Text("Васюкова Елена Андреева").tag(Vrachi.Vasukova)
                    Text("Без врача").tag(Vrachi.without)
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                .frame(width: UIScreen.main.bounds.width-30)
                .clipped()
                .compositingGroup()
                Divider()
                HStack(){
                    Button(action: {
                        withAnimation {
                            pV.toggle()
                        }
                    }){
                        Text("Отменить")
                    }.buttonStyle(TransparentButton())
                    Divider()
                    Button(action: {
                        addVrach(pVrach: selectedVrach.rawValue)
                        withAnimation {
                            pV.toggle()
                        }
                    }){
                        Text("Сохранить")
                    }.buttonStyle(TransparentButton())
                }.frame(height: 50)
            }
            .background(Color.white.cornerRadius(10))
            .padding([.leading, .trailing], 15)
        }
        .onAppear {
            selectedVrach = getPreloadDoc()
        }
    }
}
