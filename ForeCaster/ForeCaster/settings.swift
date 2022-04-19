//
//  settings.swift
//  ForeCaster
//
//  Created by Lucas Laje (student LM) on 3/21/22.
//

import Foundation
import SwiftUI

struct darkMode: Codable{
    var on = false
}

class idealTime: ObservableObject{
    var tempNum : Double = 0
    var rain = 0
    var snow = 0
    var data : [Hour]
    var humidity = 0
    init(data: [Hour] = [Hour](), tempNum : Double, rain : Int, snow : Int, humidity : Int){
        self.data = data
        self.tempNum = tempNum
        self.rain = rain
        self.snow = snow
        self.humidity = humidity
    }
    
    
    func findIdealTime(){
        
        for index in (0..<data.count).reversed(){
            
            if data[index].temp_f > tempNum+2 || data[index].temp_f < tempNum - 2{
                data.remove(at: index)
            }
            else if data[index].will_it_rain != rain{
                data.remove(at: index)
            }
            else if data[index].will_it_snow != snow{
                data.remove(at: index)
            }
            else if data[index].humidity < humidity-5 || data[index].humidity > humidity+5{
                data.remove(at: index)
            }
            
            
        }
        
        
    }
    func setRain(r: Bool){
        if r{
            self.rain = 1
        }else{
            self.rain = 0
        }
    }
    func setSnow(s: Bool){
        if s{
            self.snow = 1
        }else{
            self.snow = 0
        }
    }
}

struct idealTempModleView: View{
    @Environment(\.presentationMode) private var presentationMode
    @State var rain = false
    @State var snow = false
    @StateObject var f = FetchData()
    
    @StateObject var idealism = idealTime(data: FetchData().responses.forecast.forecastday[0].hour, tempNum: 0.0, rain: 0, snow: 0, humidity: 0)
    
    var intProxy: Binding<Double>{
        Binding<Double>(get: {
            //returns the score as a Double
            return Double(idealism.humidity)
        }, set: {
            //rounds the double to an Int
            
            idealism.humidity = Int($0)
        })
    }
    
    var body: some View{
        
        VStack{
            Spacer()
            
            HStack{
                Toggle(isOn: $rain, label: {Text("Rain?")})
                Toggle(isOn: $snow, label: {Text("Snow?")})
                
            }.background(Color.customGray.opacity(0.8))
            Spacer()
            HStack{
                Slider(value: intProxy, in: (0...100))
                Text("% humidity: \(idealism.humidity)")
            }.background(Color.customGray.opacity(0.8))
            Spacer()
            HStack{
                Slider(value: $idealism.tempNum, in: (-40...120))
                Text("Ideal Temperature in Fahrenheit: \(idealism.tempNum)")
            }.background(Color.customGray.opacity(0.8))
            Spacer()
            Button("Schedule Notification") {
                //twentyFourHourClock = true
                //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                // UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                
                
                let content = UNMutableNotificationContent()
                content.title = "Ideal Temperature"
                content.subtitle = "keyWord"
                content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 100.0)
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(1), repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
                
                
                
            }.buttonStyle(NeumorphicButtonStyle(bgColor: Color.customGray))
            Spacer()
            Button("Remove Notifications") {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            }.buttonStyle(NeumorphicButtonStyle(bgColor: Color.customGray))
        }.background(Color.customBlue)
    }
}
