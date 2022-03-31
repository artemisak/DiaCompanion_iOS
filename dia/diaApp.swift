//
//  diaApp.swift
//  dia
//
//  Created by Артем  on 03.07.2021.
//

import SwiftUI

@main
struct diaApp: App {
    var body: some Scene {
        WindowGroup {
            startPage()
                .preferredColorScheme(.light)
        }
    }
    init(){
        Thread.sleep(forTimeInterval: 0.2)
    }
}
