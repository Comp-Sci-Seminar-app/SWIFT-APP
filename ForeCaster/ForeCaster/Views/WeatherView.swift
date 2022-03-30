//
//  WeatherView.swift
//  ForeCaster
//
//  Created by Ari Bredbenner (student LM) on 2/24/22.
//

import SwiftUI
import struct Kingfisher.KFImage
import UserNotifications

func makeTimeNice(_ evilTime: String)-> String{
    @AppStorage("24h") var twentyFourHourClock = true
    //2022-02-24T(11)10:00:00-05:00
    
    
    let start = evilTime.dropFirst(11)
    
    let end = start.dropLast(9)
    
    var niceTime = String(end)
    
    if niceTime.first == "0"{
        
        niceTime = String(niceTime.dropFirst())
        
    }
    
    else if !twentyFourHourClock{
        
        for i in 13...24{
            
            if niceTime.hasPrefix(String(i)){
                
                if !twentyFourHourClock{
                    
                    return String(i-12)+String(niceTime.dropFirst(2))+" PM"
                    
                }
                
                else{
                    
                    return String(i-12)+String(niceTime.dropFirst(2))
                    
                }
                
            }
            
        }
        
    }
    
    if !twentyFourHourClock{
        
        return niceTime+" AM"
        
    }
    
    else{
        
        return niceTime
        
    }
    
}

struct WeatherView: View {
    @StateObject var g = Decoded()
    @StateObject var f = FetchData()
    @AppStorage("24h") var hours : Bool = true
    init(){
        Theme.navigationBarColors(background: .clear, titleColor: .clear)
    }
    var t: [Int] = [0,1,2,3,4,5,6,7,8,9,10]
    var body: some View {
        Button("Schedule Notification") {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            
            for i in t {
                let content = UNMutableNotificationContent()
                content.title = "Weather Notification"
                content.subtitle = "Rain"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval((60 * (i + 1))), repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 100.0)
                UNUserNotificationCenter.current().add(request)
            }
        }
        
        NavigationView{
            List{
                Button(action: {hours.toggle()}) {
                    Text("change hours")
                }
                ForEach(0..<156) { index in
                    
                    NavigationLink(
                        destination:
                            AdvancedHourlyView(data: $g.hForecast.properties.periods[index])
                        
                        , label: {
                            
                            
                            Text("\(index)")
                            
                        })
                    
                    
                }
            }
            
        }
    }
}
