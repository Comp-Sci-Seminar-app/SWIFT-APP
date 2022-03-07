//
//  ContentView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 2/24/22.
//

import SwiftUI
import struct Kingfisher.KFImage

func makeTimeNice(_ evilTime: String)-> String{
    @AppStorage("24h") var twentyFourHourClock = true
    //2022-02-24T(11)10:00:00-05:00

    

    let start = evilTime.dropFirst(11)

    let end = start.dropLast(9)

    var niceTime = String(end)

    if niceTime.first == "0"{

        niceTime = String(niceTime.dropFirst())

    }

    else if !twentyFourHourClock{

        for i in 13...24{

            if niceTime.hasPrefix(String(i)){

                if !twentyFourHourClock{

                    return String(i-12)+String(niceTime.dropFirst(2))+" PM"

                }

                else{

                    return String(i-12)+String(niceTime.dropFirst(2))

                }

            }

        }

    }

    if !twentyFourHourClock{

        return niceTime+" AM"

    }

    else{

        return niceTime

    }

}

struct ContentView: View {
    @StateObject var g = Decoded()
    @StateObject var f = FetchData()
    @AppStorage("24h") var hours : Bool = true
    init(){
        Theme.navigationBarColors(background: .clear, titleColor: .clear)
    }
    var body: some View {
         NavigationView{
             List{
                Button(action: {hours.toggle()}) {
                    Text("change hours")
                }
                ForEach(0..<156) { index in
        
                    NavigationLink(
                        destination:
                            AdvancedHourlyView(data: $g.hForecast.properties.periods[index])
        
                       , label: {
        
        
                           Text("\(index)")
        
                        })
        
        
                 }
             }
        
         }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
