//
//  BypassIndicator.swift
//  dia
//
//  Created by Артём Исаков on 22.02.2023.
//

import Foundation
import SwiftUI

protocol BypassIndicator {
    var value: Double { get }
    var label: String { get }
    var lowerBound: Double { get }
    var upperBound: Double { get }
    var bgColor: Color { get }
}
