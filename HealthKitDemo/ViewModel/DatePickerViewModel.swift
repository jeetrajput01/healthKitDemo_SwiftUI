//
//  DatePickerViewModel.swift
//  HealthKitDemo
//
//  Created by differenz147 on 02/11/21.
//

import Foundation


class DatePickerViewModel: ObservableObject {
    
    @Published var selectedDate = Date()
    @Published var stepData:String = ""
    @Published var isShowAlert = false
    var healthStoreObj = HealthStore()
    
}

 
extension DatePickerViewModel {
    
    func saveStepDataInHealthApp() {

        let noOfSteps = stepData.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        
        if noOfSteps == "" {
            return
        }
        self.healthStoreObj.saveStepDataInHealth(selectedDate: self.selectedDate, steps: Int(noOfSteps) ?? 0) { error in
            
            if error == nil {
                DispatchQueue.main.async {
                    self.isShowAlert = true
                }
            } else {
                
            }
            
        }
       
        
    }
    
}
