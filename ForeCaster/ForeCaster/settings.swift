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
    
    
    
    
}

struct idealTempModleView: View{
    @Environment(\.presentationMode) private var presentationMode
    @State var rain = false
    @State var snow = false
    @State var humidity = 0
    @State var temp = 0.0
    @StateObject var f = FetchData()
    
    
    var intProxy: Binding<Double>{
        Binding<Double>(get: {
            //returns the score as a Double
            return Double(humidity)
        }, set: {
            //rounds the double to an Int
            
            humidity = Int($0)
        })
    }
    
    var body: some View{
        
        VStack{
            
            Spacer()
            Text("Hours that match conditions will show up green. otherwise it will be gray. If humidity is -1 then it will be ignored.").frame(width: UIScreen.main.bounds.width).background(Color.customGray).font(.system(size: 20))
            Toggle(isOn: $rain, label: {
                Text("Rain?").frame(width: UIScreen.main.bounds.width - 30).background(Color.customGray)
            })
            Toggle(isOn: $snow, label: {
                Text("Snow?").frame(width: UIScreen.main.bounds.width - 30).background(Color.customGray)
            })
            VStack{
                Text("Humidity: \(humidity)").frame(width: UIScreen.main.bounds.width).background(Color.customGray)
                Slider(value: intProxy, in: -1...100){
                    
                }.padding().accentColor(.yellow).overlay(
                    RoundedRectangle(cornerRadius: 15.0)
                        .stroke(lineWidth: 2.0)
                        .foregroundColor(Color.yellow)
                )
                
            }
            VStack{
                Text("Temperature \(temp)").frame(width: UIScreen.main.bounds.width).background(Color.customGray)
                Slider(value: $temp, in: -40...120){
                    
                }.padding().accentColor(.yellow).overlay(
                    RoundedRectangle(cornerRadius: 15.0)
                        .stroke(lineWidth: 2.0)
                        .foregroundColor(Color.yellow)
                )
                Spacer()
                
            }
            ScrollView(.horizontal){
                HStack{
                    ForEach(0..<24){ i in
                        ZStack{
                            Group{
                                
                                if findIdealTime(h: f.responses.forecast.forecastday[0].hour[i], tempNum: temp, rain: rain, snow: snow, humidity: humidity){
                                    Rectangle().frame(width: 100, height: 100).foregroundColor(Color.green).cornerRadius(30)
                                }else{
                                    Rectangle().frame(width: 100, height: 100).foregroundColor(Color.customGray).cornerRadius(30)
                                }
                                
                            }
                            VStack{
                                Text("Time:")
                                Text("\(timeToInt(f.responses.forecast.forecastday[0].hour[i].time)):00")
                            }
                        }
                    }
                }
            }
        }.background(Color.blue)
    }
}


func findIdealTime(h: Hour, tempNum: Double, rain: Bool, snow: Bool, humidity: Int) -> Bool{
    var rainNum = 0
    var snowNum = 0
    
    if rain{
        rainNum = 1
    }
    
    if snow{
        snowNum = 1
    }
    
    
    if h.temp_f > tempNum+5 || h.temp_f < tempNum - 5{
        return false
    }
    else if h.will_it_rain != rainNum{
        return false
    }
    else if h.will_it_snow != snowNum{
        return false
    }
    else if h.humidity < humidity-5 || h.humidity > humidity+5{
        if humidity > -1{
            return false
        }
    }
    
    return true
    
    
    
    
}
