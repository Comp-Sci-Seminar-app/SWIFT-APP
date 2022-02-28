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
        // NavigationView{
        //     List{
        //        ForEach(0..<156) { index in
        
        //            NavigationLink(
        //                destination:
        //                    AdvancedHourlyView(data: $g.hForecast.properties.periods[index])
        
        //               , label: {
        
        
        //                   Text("\(index)")
        
        //                })
        
        
        //         }
        //     }
        ZStack{
            VStack{
                Text("sadness")
            }.frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - 40, alignment: .center).background(Color.gray).cornerRadius(20)
            
            
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center).background(Color.blue).ignoresSafeArea(.all)
        Spacer()
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
