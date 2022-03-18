//
//  DailyView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 3/18/22.
//

import SwiftUI

struct DailyView: View {
    var dayInfo : DPeriods
    var hInfo : [HPeriods]
    var body: some View {
        VStack{
            Spacer()
            Text("\(dayInfo.detailedForecast)")
            Spacer()
            ScrollView(.horizontal){
                Spacer()
                VStack{
                    Text("Wind Speed:")
                    Text("\(dayInfo.windSpeed) mph")
                }.frame(width: 80, height: 80).background(Color.customBlue.opacity(0.6))
                
                Spacer()
                VStack{
                    Text("Temperature:")
                    Text("\(dayInfo.temperature) mph")
                }.frame(width: 80, height: 80).background(Color.customBlue.opacity(0.6))
                
                Spacer()
                VStack{
                    Text("Wind Direction:")
                    Text("\(dayInfo.windSpeed) mph")
                }.frame(width: 80, height: 80).background(Color.customBlue.opacity(0.6))
                
                Spacer()
            }
            Spacer()
            
        }
    }
}
