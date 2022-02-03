//
//  ContentViewModel.swift
//  HealthKitDemo
//
//  Created by differenz147 on 01/11/21.
//

import Foundation

let kMoveToDatePicker = "moveToDatePicker"

class ContentViewModel: ObservableObject {
    @Published var healthStoreObj: HealthStore?
    @Published var steps: [Step] = [Step]()
    @Published var isShowAlert = false
    @Published var navigation:String? = nil
    
    init() {
        healthStoreObj = HealthStore()
    }
    
}


extension ContentViewModel {
    
    
    
    func healthKitPermission() {
        
        if let healthKit = self.healthStoreObj {
            healthKit.requestAuth { success in
                if success {
                    DispatchQueue.main.async {
                        self.steps.removeAll()
                    }
                    healthKit.calculateStep { StatisticsCollection in

                        if let collection = StatisticsCollection {
                            self.updateUIFromStatistics(collection)
                        }
                        DispatchQueue.main.async {
                            healthKit.getBOD()
                            healthKit.getBloodGroup()
                            healthKit.getUserSex()
                        }
                    }
                }
            }
        }
        
    }
    
    func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            DispatchQueue.main.async {
                self.steps.append(step)
            }
           
        }
        
    }
    
    func checkStepPermission() {
        if let healthKit = self.healthStoreObj {
            if healthKit.checkStepWritePermission() {
                
                self.navigation = kMoveToDatePicker
                
            } else {
                self.isShowAlert = true
            }
        }
    }
    
}
