//
//  SettingsView.swift
//  ForeCaster
//
//  Created by Ari Bredbenner (student LM) on 2/24/22.
//

import SwiftUI

struct SettingsView: View {
    var t: [Notification] = [Notification(weather: "Sun", time: 120.0), Notification(weather: "Rain", time: 60.0)]
    
    
    //Only goes in hours
    func timeInSeconds(p : String) -> Double {
        var multiplier: Double = 1.0
        if p == "8:00 AM"{
            multiplier = 1.0
        }
        return 3600.0 * multiplier
    }
    
    var body: some View {
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
                
                for i in t{
                    i.setNotification(t: i)
                }
            }
            Button("Remove Notifications") {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            }
        }
    }
}

