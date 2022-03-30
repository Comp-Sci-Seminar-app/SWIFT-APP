//
//  WeatherView.swift
//  ForeCaster
//
//  Created by Ari Bredbenner (student LM) on 2/24/22.
//

import SwiftUI
import struct Kingfisher.KFImage
import UserNotifications



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
             
            }
            
        }
    }
}
