//
//  GraphView.swift
//  HealthKitDemo
//
//  Created by differenz147 on 01/11/21.
//

import SwiftUI

struct GraphView: View {
    
    
    static let dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
        
    }()
    
    let steps: [Step]
    let healthObj: HealthStore?
    
    var totalSteps: Int {
        steps.map { $0.count }.reduce(0,+)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                
                ForEach(steps, id: \.id) { step in
                    
                    let yValue = min(step.count/20, 300)
                    
                    VStack {
                        Text("\(step.count)")
                            .font(.caption)
                            .foregroundColor(Color.white)
                        Rectangle()
                            .fill(step.count > 10000 ? Color.green : Color.red)
                            .frame(width: 20, height: CGFloat(yValue))
                        Text("\(step.date,formatter: Self.dateFormatter)")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    }
                }
                
            }
            
            Text("Total Steps: \(totalSteps)").padding(.top, 100)
                .foregroundColor(Color.white)
                .opacity(0.5)
            Text("Birth Of Date = \(healthObj?.BOD ?? "dcfhschjs")").foregroundColor(.white).opacity(0.5)
            Text("Sex = \(healthObj?.userSex ?? "sdcsac")").foregroundColor(.white).opacity(0.5)
            Text("Blood Group = \(healthObj?.user_Blood_group ?? "cadscads")").foregroundColor(.white).opacity(0.5)
            
            
        }
        .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height * 0.7, alignment: .center)
        .background(Color(#colorLiteral(red: 0.2471546233, green: 0.4435939193, blue: 0.8302586079, alpha: 1)))
        .cornerRadius(10)
        .padding(10)
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        
        let steps = [
                   Step(count: 3452, date: Date()),
                   Step(count: 123, date: Date()),
                   Step(count: 1223, date: Date()),
                   Step(count: 5223, date: Date()),
                   Step(count: 12023, date: Date())
               ]
        
        GraphView(steps: steps, healthObj: HealthStore())
    }
}
