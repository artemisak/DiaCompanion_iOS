//
//  weekS.swift
//  dia
//
//  Created by Артем  on 21.10.2021.
//

import SwiftUI

struct weekS: View {
    @Binding var bWeek: Bool
    @State private var selections1: [Double] = [20, 3]
    private let data1: [[Double]] = [
        Array(stride(from: 0, through: 40, by: 1)),
        Array(stride(from: 0, through: 7, by: 1))
    ]
    var body: some View {
        ZStack{
            Color(.black)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture{withAnimation(.linear){bWeek.toggle()}}
            VStack(spacing:0){
                Text("Неделя беременности на начало исследования")
                    .multilineTextAlignment(.center)
                    .padding()
                Divider()
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("Неделя")
                        Spacer()
                        Text("День")
                        Spacer()
                    }
                    MultiWheelPicker(selections: $selections1, data: data1)
                }
                .padding()
                Divider()
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation {
                            bWeek.toggle()
                        }
                    }){
                        Text("Отменить")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    Divider()
                    Button(action: {
                        addWeekDay(week: Int(selections1[0]), day: Int(selections1[1]))
                        withAnimation {
                            bWeek.toggle()
                        }
                        UIApplication.shared.dismissedKeyboard()
                    }){
                        Text("Сохранить")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                }.frame(height: 50)
            }
            .background(Color.white.cornerRadius(10))
            .frame(maxWidth: 350)
        }
    }
}

struct MultiWheelPicker: UIViewRepresentable {
    var selections: Binding<[Double]>
    let data: [[Double]]
    
    func makeCoordinator() -> MultiWheelPicker.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MultiWheelPicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<MultiWheelPicker>) {
        for comp in selections.indices {
            if let row = data[comp].firstIndex(of: selections.wrappedValue[comp]) {
                view.selectRow(row, inComponent: comp, animated: false)
            }
        }
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: MultiWheelPicker
      
        init(_ pickerView: MultiWheelPicker) {
            parent = pickerView
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return parent.data.count
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.data[component].count
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 48
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return String(format: "%02.0f", parent.data[component][row])
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selections.wrappedValue[component] = parent.data[component][row]
        }
    }
}
