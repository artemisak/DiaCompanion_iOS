//
//  recipeCard.swift
//  dia
//
//  Created by Артём Исаков on 06.03.2023.
//

import SwiftUI

struct recipeCard: View {
    @State var imageURL: URL?
    @State var title: String
    var body: some View {
        AsyncImage(url: imageURL, content: {image in
            image.resizable().scaledToFill()
        }, placeholder: {
            LinearGradient(colors: [Color.gray, Color.gray.opacity(0.7)], startPoint: .bottom, endPoint: .top)
        })
        .frame(width: 150, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            VStack {
                Spacer()
                Text(title).font(.title3).bold().foregroundColor(.white).minimumScaleFactor(0.001).multilineTextAlignment(.leading).padding(.horizontal)
            }
        }
    }
}
