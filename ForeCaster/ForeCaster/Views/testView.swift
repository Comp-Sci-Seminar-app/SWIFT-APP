//
//  testView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 3/21/22.
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
        let allHourly = g.hForecast.properties.periods//all of the important info passed by the API for hourly
        let heightOffset = 90+offset.y//the normal offset is 90 off because of how spacers work in scrollviews, this makes it
        ZStack{
            NavigationView{
                ScrollView(showsIndicators: false) {
                    //scrollview with the actual info
                    //Spacer().frame(width: 100, height: heightOffset, alignment: .center)
                    //the actual info
                    Spacer().frame(width: 5)//Keeps the blocks off the side of the screen and looks 100x better
                        ForEach(1..<7){index in//goes through all the info
                            
                            NavigationLink(destination: DailyView(dayInfo : allDaily[(index * 2) - 1] , hInfo : allHourly ), label: {
                                VStack{//one block containing text in the horizontal scrollview
                                    
                                    Text(allDaily[index].name).foregroundColor(.white)
                                    Text(" \(Image(systemName: "thermometer")) \(allDaily[index].temperature) \(allDaily[index].temperatureUnit) ").foregroundColor(.white)
                                    Text(" \(Image(systemName: "wind")) \(allDaily[index].windSpeed) \(allDaily[index].windDirection) ").foregroundColor(.white)
                                    //Text("Forecast: \(allDaily[index].detailedForecast)").multilineTextAlignment(.center).frame(width: 40)
                                }.background(Color.blue.opacity(0.5))
                                .cornerRadius(10)
                                .frame(alignment: .center)
                                
                                
                            })
                            //makes it look nice
                            
                            
                            Spacer()//keeps the blocks seperate
                        }
                    
                    
                    
                    
                    
                }.readingScrollView(from: "scroll", into: $offset)//idk abt this
                Spacer().frame(width: 100, height: 100, alignment: .center)//makes space between views
                Spacer().frame(width: 100, height: 100, alignment: .center)//makes space between views
            }
        }
    }
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
    }
}
