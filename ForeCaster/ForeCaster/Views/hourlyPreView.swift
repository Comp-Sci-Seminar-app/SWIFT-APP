//
//  hourlyPreView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 3/23/22.
//

import SwiftUI

struct hourlyPreView: View {
    var i : Int
    var hInfo : [HPeriods]
    var body: some View {
        VStack{
            
            Text(" \(makeTimeNice(hInfo[i].startTime)) ").foregroundColor(.white)//this gets the time, thats the only real difference other than the actual values
            Text(" \(Image(systemName: "thermometer")) \(hInfo[i].temperature) \(hInfo[i].temperatureUnit) ").foregroundColor(.white)
            if !(hInfo[i].windSpeed.hasPrefix("0")){
                Text(" \(Image(systemName: "wind")) \(hInfo[i].windSpeed) \(hInfo[i].windDirection) ").foregroundColor(.white)
            }
            else{
                Text(" \(Image(systemName: "wind")) 0 mph ").foregroundColor(.white)
            }
            //Text("Forecast: \(allDaily[index].detailedForecast)").multilineTextAlignment(.center).frame(width: 40)
        }.background(Color.customBlue.opacity(0.5))
        .cornerRadius(10)
        .frame(alignment: .center)
    }
}

