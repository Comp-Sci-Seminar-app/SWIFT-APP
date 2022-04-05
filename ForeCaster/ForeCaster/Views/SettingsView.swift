//
//  SettingsView.swift
//  ForeCaster
//
//  Created by Ari Bredbenner (student LM) on 2/24/22.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @StateObject var g = Decoded()// new API
    @StateObject var f = FetchData()// old API
    
    
    var body: some View {
        let allHourly = g.hForecast.properties.periods

        VStack {
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Schedule Notification") {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                
                for i in returnHourList(hp: allHourly){
                    let content = UNMutableNotificationContent()
                    content.title = "Weather Notification"
                    content.subtitle = "Rain"
                    content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 100.0)
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i * 2), repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request)
                    print("\(i)")
                }
                
            }
            Button("Remove Notifications") {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            }
        }
    }
}

