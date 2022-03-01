//
//  AdvancedHourlyView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 2/24/22.
//

import SwiftUI

struct AdvancedHourlyView: View {
    @Binding var data : HPeriods
    
    var body: some View {
        ZStack{
            ZStack{
            VStack{
                Spacer()
                Text("Forcast for \(makeTimeNice(data.startTime))").frame(width: UIScreen.main.bounds.width - 80, height: 50).background(Color.gray.opacity(0.8)).cornerRadius(10)
                Spacer()
                VStack{
                    HStack{
                        Spacer()
                        Text("Wind speed: \(data.windSpeed)")
                        Spacer()
                        Text("Wind direction \(data.windDirection)")
                        Spacer()
                    }.frame(width: UIScreen.main.bounds.width - 80, height: 40)
                    HStack{
                        Spacer()
                        Text("Temperature: \(data.temperature)")
                        Spacer()
                        Text("number? \(data.number)")
                        Spacer()
                    }.frame(width: UIScreen.main.bounds.width - 80, height: 40)
                    HStack{
                        Text("Short Forcast: \(data.shortForecast ?? "no data bro")")
                    }.frame(width: UIScreen.main.bounds.width - 80, height: 40)
                }.frame(width: UIScreen.main.bounds.width - 80, height: 120)
                Spacer()
            }.frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.height - 60).background(Color.gray.opacity(0.8))
            .background(Color.blue).cornerRadius(30)
            }.frame(width: UIScreen.main.bounds.width-30, height: UIScreen.main.bounds.height-30).background(Color.gray).cornerRadius(30)
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).background(Color.blue).ignoresSafeArea(.all)
    }
}

