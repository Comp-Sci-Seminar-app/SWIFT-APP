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
    var condition : String = ""
    var data = Forecastday().hour
    var humidity = 0
    
    func findIdealTime(){
        
        for i in data{
            var index = 1
            
            if i.temp_f > tempNum+2 || i.temp_f < tempNum - 2{
                data.remove(at: index)
            }
            if i.will_it_rain != rain{
                data.remove(at: index)
            }
            if i.will_it_snow != snow{
                data.remove(at: index)
            }
            if i.humidity < humidity-5 || i.humidity > humidity+5{
                data.remove(at: index)
            }

           index += 1
        }
        
        
    }
}
