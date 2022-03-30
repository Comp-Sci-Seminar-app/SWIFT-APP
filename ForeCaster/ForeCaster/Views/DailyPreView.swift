//
//  DailyPreView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 3/21/22.
//

import SwiftUI

struct DailyPreView: View {
    var index : Int
    var allDaily : [DPeriods]
    
    var body: some View {
        
        VStack{//one block containing text in the horizontal scrollview
            
            Text(allDaily[index].name).foregroundColor(.white)
            Text(" \(Image(systemName: "thermometer")) \(allDaily[index].temperature) \(allDaily[index].temperatureUnit) ").foregroundColor(.white)
            Text(" \(Image(systemName: "wind")) \(allDaily[index].windSpeed) \(allDaily[index].windDirection) ").foregroundColor(.white)
            //Text("Forecast: \(allDaily[index].detailedForecast)").multilineTextAlignment(.center).frame(width: 40)
        }.background(Color.blue.opacity(0.5))
        .cornerRadius(10)
        .frame(alignment: .center)
    }
}
