//
//  export.swift
//  dia
//
//  Created by Артем  on 01.09.2021.
//

import SwiftUI

struct export: View {
    var anatomy = Anatomy()
    var body: some View {
        ScrollView{
            VStack{
                HStack {
                    Button(action:{
                        let path = anatomy.generate()
                        print("\(path)")
                    }){
                        VStack{
                            Image("menu_xlsx")
                            Text("Показать данные в \n таблице").foregroundColor(Color.black).multilineTextAlignment(.center)
                        }
                    }
                    Button(action:{}){
                        VStack{
                            Image("menu_mail")
                            Text("Отправить данные \n врачу").foregroundColor(Color.black).multilineTextAlignment(.center)
                        }
                    }
                }
            }
        }
        .padding(.top)
        .navigationBarTitle("Экспорт данных")
    }
}

struct export_Previews: PreviewProvider {
    static var previews: some View {
        export()
    }
}
