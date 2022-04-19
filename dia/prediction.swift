import Foundation
import SwiftUI

func getPredict(sugar: String) -> (String, Color) {
    if (sugar == ""){
        return ("УСК не определен", Color.black)
    } else if (Double(sugar) ?? 5.0 > 7){
        return ("УСК превысит норму", Color.red)
    } else {
        return ("УСК в норме", Color.green)
    }
}
