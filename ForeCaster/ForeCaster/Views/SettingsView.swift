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
            //Requests permission to send notifications
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            
            //Makes notifications based on specified word
            Button("Schedule Notification") {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                
                //Creates the notifications
                for i in returnHourList(hp: allHourly){
                    let content = UNMutableNotificationContent()
                    //Title
                    content.title = "Weather Notification"
                    //Subtitle or message
                    content.subtitle = "Rain"
                    //Custom sound
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "kricketune.mp3"))
                    //When it triggers
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i * 2), repeats: false)
                    //Create request
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    //add the request fully
                    UNUserNotificationCenter.current().add(request)
                    //Debug
                    print("\(i)")
                }
                
            }
            //Removes all notifications that exist
            Button("Remove Notifications") {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            }
        }
    }
}


