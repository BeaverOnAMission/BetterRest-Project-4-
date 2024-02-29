//
//  ContentView.swift
//  BetterRest(Project 4)
//
//  Created by mac on 13.08.2022.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var result = "Your ideal bedtime is: "

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }

    var body: some View {
        VStack{
            
            Spacer()
            
            Text("BETTER REST").font(.largeTitle.bold())
           
           Spacer()
            
            Group{
                    Text("What time do you want to wake up?")
                    .font(.title2)
                
                HStack{
                   
                   DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding(20)
                    
                    Spacer()
                }
                
                    Text("Desired amount of sleep")
                    .font(.title2)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    .padding(20)

                    Text("Daily coffee intake")
                    .font(.title2)
                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                    .padding(20)
                
                Spacer()
                
            }
            
            Text("\(result)").font(.title.bold())
            
            Spacer()
            Spacer()
            
            Button (action: calculateBedtime, label: {
               Text("CALCULATE")
                    .font(.title)
                     .frame(width: 320, height: 90)
                    .background(Color("Color-1"))
                    .foregroundColor(Color("Color"))
                    } )
                .cornerRadius( 10 )
                .background(.thickMaterial)
            
            Spacer()
            Spacer()
            
        } .ignoresSafeArea()
            .background(.thickMaterial)
            .background(Color("Color"))
            .preferredColorScheme(.light)
           
    }

    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try Calc(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep
           
            result = "Your ideal bedtime is: \(sleepTime.formatted(date: .omitted, time: .shortened))"
        } catch {
     
            result = "Sorry, there was a problem calculating your bedtime."
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

