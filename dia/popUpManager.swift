//
//  popUpManager.swift
//  dia
//
//  Created by Артём Исаков on 04.09.2022.
//

import Foundation

class addFood : ObservableObject {
    
    @Published var isShown = false
    @Published var success = false
    
    func hideView() {
        self.isShown = false
    }
    
    func showSuccessNotice() {
        self.success = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.75, execute: {
            self.success = false
        })
    }
    
    func hideSuccessNotice() {
        self.success = false
    }
    
    func showView() {
        self.isShown = true
        self.success = false
    }
    
}

