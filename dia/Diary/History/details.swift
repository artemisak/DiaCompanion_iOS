//
//  details.swift
//  dia
//
//  Created by Артём Исаков on 08.11.2022.
//

import SwiftUI

let highIntensity = Legend(color: .orange, label: "High Intensity", order: 5)
let buildFitness = Legend(color: .yellow, label: "Build Fitness", order: 4)
let fatBurning = Legend(color: .green, label: "ГН", order: 3)
let warmUp = Legend(color: .blue, label: "БЖУ", order: 2)
let low = Legend(color: .gray, label: "ККал", order: 1)

let limit = DataPoint(value: 130, label: "5", legend: fatBurning)

struct details: View {
    let points: [DataPoint] = [
        .init(value: 70, label: "1", legend: low),
        .init(value: 90, label: "2", legend: warmUp),
        .init(value: 91, label: "3", legend: warmUp),
        .init(value: 92, label: "4", legend: warmUp),
        .init(value: 130, label: "5", legend: fatBurning),
    ]
    var body: some View {
        BarChartView(dataPoints: points, limit: limit)
        .padding()
    }
}

struct details_Previews: PreviewProvider {
    static var previews: some View {
        details()
    }
}
