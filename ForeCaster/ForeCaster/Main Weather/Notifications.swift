//
//  Notifications.swift
//  ForeCaster
//
//  Created by Ari Bredbenner (student LM) on 3/24/22.
//

import Foundation
import UserNotifications

struct Notification: Identifiable{
    
    var weather: String
    var time: Double
    var id = UUID()
    
    init(weather: String = "Rain", time: Double = 60.0){
        self.weather = weather
        self.time = time
    }
    
    func setNotification(t : Notification){
        let content = UNMutableNotificationContent()
        content.title = "Weather Notification"
        
        if t.weather == "Rain" {
            content.subtitle = "Rain"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: t.time, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 100.0)
            UNUserNotificationCenter.current().add(request)
        }
        else{
            content.subtitle = "Bright and Sunny"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: t.time, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 100.0)
            UNUserNotificationCenter.current().add(request)
        }
    }
}
