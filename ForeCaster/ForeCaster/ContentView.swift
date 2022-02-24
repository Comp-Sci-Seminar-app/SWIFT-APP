//
//  ContentView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 2/24/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var g = Decoded()
    @StateObject var f = FetchData()
    var body: some View {
        NavigationView{
            List{
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
