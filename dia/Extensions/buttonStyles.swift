import SwiftUI
import Foundation

struct ChangeColorButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.clear)
            .foregroundColor(.accentColor)
    }
}

struct RoundedRectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color("listHeader_alt").cornerRadius(8))
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}

struct TransparentButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.0001))
            .foregroundColor(Color("listButtonColor"))
            .frame(height: 50)
    }
}

struct ButtonAndLink: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.white.opacity(0.0001))
    }
}

struct centerLabel: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            configuration.icon
            configuration.title
        }.padding(.vertical, 5)
    }
}
