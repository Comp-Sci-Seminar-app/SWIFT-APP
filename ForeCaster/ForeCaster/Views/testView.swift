//
//  testView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 3/21/22.
//
//  This view is for when something bigger in contentview isn't working, and I want to test it in another branch.
//

import SwiftUI

struct testView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var g = Decoded()// new API
    @StateObject var f = FetchData()// old API
    @State var offset: CGPoint = .zero// this is the offset of the scroll view
    @State var coeffOfWidth = (UIScreen.main.bounds.width/2)-73
    @State private var showingSheet = true
    var body: some View {
        let allDaily = g.dForecast.properties.periods//all of the important info passed by the API for daily
        let hInfo = g.hForecast.properties.periods//all of the important info passed by the API for hourly
        let heightOffset = 90+offset.y//the normal offset is 90 off because of how spacers work in scrollviews, this makes it
        var hLeft = getHowManyHoursAreLeftInToday()
        let allHourly = g.hForecast.properties.periods
        
        VStack{
            
        //    ForEach((hLeft + (24 * (index - 1)))..<(hLeft + (24 * index))){i in
           
       //         Spacer()
       //     }
            //.opacity(0)
            //     hourlyPreView(i:i, hInfo: hInfo)
            Text("\(allDaily[0].detailedForecast)")
            Button(action: {returnHourList(hp: allHourly)}, label: {
                Text("thingy")
            })
            Button(action: {print(getHourOffset(allHourly[0]))}, label: {
                Text("thingy2")
            })
        }
    }
}
    
