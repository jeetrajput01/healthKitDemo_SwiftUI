//
//  HealthStore.swift
//  HealthKitDemo
//
//  Created by differenz147 on 01/11/21.
//

import Foundation

class HealthStore {
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    var userSex: String = ""
    var user_Blood_group: String = ""
    var BOD: String = ""
    private var stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    
    func requestAuth(completion: @escaping (Bool) -> Void) {
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            return completion(false)
        }
        
        
        guard let sexType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex) else {
            return completion(false)
        }
        
        guard let birthDate = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth) else {
            return completion(false)
        }
        
        guard let bloodGroup = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType) else {
            return completion(false)
        }
        
        guard let healthStore = self.healthStore else {
            return completion(false)
        }

        healthStore.requestAuthorization(toShare: [stepType], read: [stepType,sexType,birthDate,bloodGroup]) { isSuccess, error in
            completion(isSuccess)
        }
        
    }
    
    func calculateStep(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        self.query =  HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        self.query?.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
    
    func getUserSex() {
        
        guard let healthStore = self.healthStore else {
            return
        }
        
        if try! healthStore.biologicalSex().biologicalSex == .male {
            self.userSex = "Male"

        } else if try! healthStore.biologicalSex().biologicalSex == .female {
            self.userSex = "FeMale"
            
        } else if try! healthStore.biologicalSex().biologicalSex == .other {
            self.userSex = "Other"
        } else {
            self.userSex = "No Set"
        }
    }
    
    
    func getBOD() {
        guard let healthStore = self.healthStore else {
            return
        }
        do {
          let dateOfBirthComponent =  try healthStore.dateOfBirthComponents()
            let date = Calendar.current.date(from: dateOfBirthComponent)
            let dateFormatter = DateFormatter()

            // Set Date Format
            dateFormatter.dateFormat = "dd/MM/yyyy"

            // Convert Date to String
            self.BOD = dateFormatter.string(from: date ?? Date())
            
        } catch {
            print(error)
        }
        
    }
    
    func getBloodGroup() {
        
        guard let healthStore = self.healthStore else {
            return
        }
    
        if try! healthStore.bloodType().bloodType == .aNegative {
            self.user_Blood_group = "A-"
        } else if try! healthStore.bloodType().bloodType == .aPositive {
            self.user_Blood_group = "A+"
        } else if try! healthStore.bloodType().bloodType == .abNegative {
            self.user_Blood_group = "AB-"
        } else if try! healthStore.bloodType().bloodType == .abPositive {
            self.user_Blood_group = "AB+"
        } else if try! healthStore.bloodType().bloodType == .bNegative {
            self.user_Blood_group = "B-"
        } else if try! healthStore.bloodType().bloodType == .bPositive {
            self.user_Blood_group = "B+"
        } else if try! healthStore.bloodType().bloodType == .oNegative {
            self.user_Blood_group = "O-"
        } else if try! healthStore.bloodType().bloodType == .oPositive {
            self.user_Blood_group = "O+"
        } else  {
            self.user_Blood_group = "No Set"
        }

    }
    
    
    func checkStepWritePermission() -> Bool {
        
        if let typeIs = self.stepType, let healthStore = self.healthStore {
            
            let statusIs = healthStore.authorizationStatus(for: typeIs)
            
            switch statusIs {
            case .notDetermined, .sharingDenied:
                return false
            case .sharingAuthorized:
                return true
            @unknown default:
                return false
            }

        }
        return false
        
    }
    
    func saveStepDataInHealth(selectedDate: Date, steps: Int,completion: @escaping (Error?) -> Void){
        
        if let stepType = self.stepType {
            
            let stepsCountUnit:HKUnit = HKUnit.count()
            let stepsCountQuantity = HKQuantity(unit: stepsCountUnit,
                                               doubleValue: Double(steps))
            
            let stepsCountSample = HKQuantitySample(type: stepType,
                                                   quantity: stepsCountQuantity,
                                                   start: selectedDate,
                                                   end: selectedDate)
            
            if let healthStore = self.healthStore {
                healthStore.save(stepsCountSample) { success, error in
                    if let error = error {
                        completion(error)
                        print("Error Saving Steps Count Sample: \(error.localizedDescription)")
                    } else {
                        completion(nil)
                        print("Successfully saved Steps Count Sample")
                    }
                }

            }

        }
        
    }
    
    
    
}


extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}
