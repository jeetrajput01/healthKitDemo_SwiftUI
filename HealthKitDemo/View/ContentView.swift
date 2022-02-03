//
//  ContentView.swift
//  HealthKitDemo
//
//  Created by differenz147 on 01/11/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var contentViewObj = ContentViewModel()

    var body: some View {
        NavigationView {
            
            GeometryReader(content: { geo in
                ZStack {
                    
                    NavigationLink("", destination: DatePickerView(), tag: kMoveToDatePicker, selection: $contentViewObj.navigation)
                    
                    ScrollView(.vertical, showsIndicators: false, content: {
                       
                        VStack {

                            GraphView(steps: contentViewObj.steps, healthObj: contentViewObj.healthStoreObj)
                                .onAppear {
                                    contentViewObj.healthKitPermission()
                                    
                                }

                            Button(action: {
                                contentViewObj.checkStepPermission()
                            }, label: {
                                Text("Add Steps")
                                    .bold()
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            })
                            .padding(.bottom, 20)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: geo.size.height, alignment: .center)
                        
                    })
                    
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
   
            })
                .navigationTitle("HealthKit Demo")
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $contentViewObj.isShowAlert, content: {
            
            Alert(title: Text("Permission Denied"), message: Text("Please provide Permission . \n To provide Permission go to Health -> steps -> Data Sources & Access"), primaryButton: Alert.Button.cancel(Text("cancel"), action: {
                print("cancel Permission")
            }), secondaryButton: Alert.Button.default(Text("ok"), action: {

                guard let url = URL(string: "x-apple-health://") else {
                    return
                }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                }
                
            }))
            
        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone SE (1st generation)")
            
    }
}
/*
 VStack {
     
    
     
 }
 */
