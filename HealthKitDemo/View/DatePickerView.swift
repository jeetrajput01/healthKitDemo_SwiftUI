//
//  DatePickerView.swift
//  HealthKitDemo
//
//  Created by differenz147 on 02/11/21.
//

import SwiftUI

struct DatePickerView: View {
    
    @StateObject var model = DatePickerViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 20) {
            DatePicker("", selection: $model.selectedDate, displayedComponents: .date)
            
            TextField("Add Steps", text: $model.stepData)
                .keyboardType(.numberPad)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08, alignment: .center)
                .border(Color.blue, width: 3)
            
            Button(action: {
               
                model.saveStepDataInHealthApp()
                
            }, label: {
                Text("Add")
                    .bold()
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 120, height: 60, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            
        }.padding()
        .alert(isPresented: $model.isShowAlert, content: {

            
            Alert(title: Text(""), message: Text("SuccessFully Add Data in \n \(model.selectedDate)"), dismissButton: .default(Text("ok"), action: {
                
                presentationMode.wrappedValue.dismiss()
                
                
            }))
            
            
        })
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView()
    }
}
