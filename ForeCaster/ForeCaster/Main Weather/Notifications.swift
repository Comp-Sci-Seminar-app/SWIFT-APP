//
//  Notifications.swift
//  ForeCaster
//
//  Created by Ari Bredbenner (student LM) on 3/24/22.
//

import Foundation

struct Notification: Identifiable{
    
    var weather: String
    var time: Double
    var id = UUID()
    
    init(weather: String = "Rain", time: Double = 60.0){
        self.weather = weather
        self.time = time
    }
}
