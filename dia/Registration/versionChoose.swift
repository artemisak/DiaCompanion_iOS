//
//  versionChoose.swift
//  dia
//
//  Created by Артём Исаков on 18.09.2022.
//

import SwiftUI


struct versionChoose: View {
    @EnvironmentObject var routeManager: Router
    @State private var GDM_RCT = true
    @State private var GDM = false
    @State private var MS = false
    @State private var PCOS = false
    var body: some View {
        List {
            Section {
                Button {
                    routeManager.version = 1
                    withAnimation(.spring()) {
                        GDM_RCT = true
                    }
                    GDM = false
                    MS = false
                    PCOS = false
                    
                } label: {
                    HStack {
                        Text("ГСД, диета (с прогнозированием)").font(.body).bold()
                        Spacer()
                        Image(systemName: "chevron.down").rotationEffect(.degrees(GDM_RCT ? 0 : -90))
                    }
                }
                .listRowBackground(GDM_RCT ? Color("listHeader_alt") : Color("listHeaderDim_alt")).foregroundColor(.white)
                if GDM_RCT {
                    Text("Версия позволяет вести контроль за приемами пищи, физической активностью и уровнем сахара в крови. В версию внедрена рекомендательная система, помогающая корректировать прием пищи пациенток.\nПредназначен для беременных пациенток, страдающих ГСД")
                }
            }
            Section {
                Button {
                    routeManager.version = 2
                    withAnimation(.spring()) {
                        GDM = true
                    }
                    GDM_RCT = false
                    MS = false
                    PCOS = false
                    
                } label: {
                    HStack {
                        Text("ГСД, инсулинотерапия").font(.body).bold()
                        Spacer()
                        Image(systemName: "chevron.down").rotationEffect(.degrees(GDM ? 0 : -90))
                    }
                }
                .listRowBackground(GDM ? Color("listHeader_alt") : Color("listHeaderDim_alt")).foregroundColor(.white)
                if GDM {
                    Text("Версия позволяет вести контроль за приемами    пищи, физической активностью и уровнем сахара в крови.\nПредназначен для беременных пациенток, страдающих ГСД")
                }
            }
            Section {
                Button {
                    routeManager.version = 3
                    withAnimation(.spring()) {
                        MS = true
                    }
                    GDM_RCT = false
                    GDM = false
                    PCOS = false
                } label: {
                    HStack {
                        Text("Дневник питания и самоконтроля").font(.body).bold()
                        Spacer()
                        Image(systemName: "chevron.down").rotationEffect(.degrees(MS ? 0 : -90))
                    }
                }
                .listRowBackground(MS ? Color("listHeader_alt") : Color("listHeaderDim_alt")).foregroundColor(.white)
                if MS {
                    Text("Версия позволяет вести контроль за приемами пищи, физической активностью и уровнем сахара в крови.\nПредназначен для пациентов, страдающих диабетом")
                }
            }
            Section {
                Button {
                    routeManager.version = 4
                    withAnimation(.spring()) {
                        PCOS = true
                    }
                    GDM_RCT = false
                    GDM = false
                    MS = false
                } label: {
                    HStack {
                        Text("Дневник питания").font(.body).bold()
                        Spacer()
                        Image(systemName: "chevron.down").rotationEffect(.degrees(PCOS ? 0 : -90))
                    }
                }
                .listRowBackground(PCOS ? Color("listHeader_alt") : Color("listHeaderDim_alt")).foregroundColor(.white)
                if PCOS {
                    Text("Версия предоставляет функционал для ведения данных о приемах пищи и физической активности.\nПодходит для пациентов, не болеющих диабетом")
                }
            } footer: {
                Text("Сделанный выбор можно изменить позже в настройках")
                    .font(.caption)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Выбор версии")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Далее", destination: generalQuestions())
            }
        }
    }
}

struct Preview_versionChoose_Previews: PreviewProvider {
    static var previews: some View {
        versionChoose()
    }
}
