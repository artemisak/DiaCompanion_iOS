//
//  Buttons.swift
//  dia
//
//  Created by Артём Исаков on 15.04.2022.
//
import SwiftUI
import Foundation

struct ChangeColorButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.clear)
            .foregroundColor(.blue)
    }
}

struct RoundedRectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label.foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(Color.blue.cornerRadius(8))
        .opacity(configuration.isPressed ? 0.75 : 1)
    }
}

struct TransparentButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .background(Color.yellow.opacity(0.0001))
            .foregroundColor(.black)
            .frame(height: 50)
    }
}
