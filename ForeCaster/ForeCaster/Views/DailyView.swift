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
    var index : Int
    var body: some View {
        var hLeft = getHowManyHoursAreLeftInToday()
        NavigationView{
            VStack{
                Spacer()
                Text("\(dayInfo.detailedForecast)")
                Spacer()
                
                ScrollView(.horizontal){
                    HStack{
                        Spacer()
                        VStack{
                            Text("Wind Speed:")
                            Text("\(dayInfo.windSpeed) mph")
                        }.frame(width: 200, height: 100).background(Color.customBlue.opacity(0.6)).cornerRadius(10)
                        
                        Spacer()
                        VStack{
                            Text("Temperature:")
                            Text("\(dayInfo.temperature) mph")
                        }.frame(width: 200, height: 100).background(Color.customBlue.opacity(0.6)).cornerRadius(10)
                        
                        Spacer()
                        VStack{
                            Text("Wind Direction:")
                            Text("\(dayInfo.windSpeed) mph")
                        }.frame(width: 200, height: 100).background(Color.customBlue.opacity(0.6)).cornerRadius(10)
                        
                        Spacer()
                    }
                }
                
                Spacer()
                ScrollView(.horizontal){
                    Group{
                        if index == 1{
                            
                            HStack{
                                ForEach(0..<getHowManyHoursAreLeftInToday()){i in
                                    hourlyPreView(i:i, hInfo: hInfo)
                                    //.opacity(0)
                                    Spacer()
                                }
                                
                            }
                        }
                        
                        else if index == 6{
                            HStack{
                                ForEach((getHowManyHoursAreLeftInToday() + 120)..<hInfo.count){i in
                                    hourlyPreView(i:i, hInfo: hInfo)
                                    //.opacity(0)
                                    Spacer()
                                }
                            }
                        }
                        else{
                            let start = hLeft + (24 * (index - 1))
                            let finish = (hLeft + (24 * index)) 
                            HStack{
                                ForEach(start..<finish){i in
                                    hourlyPreView(i:i, hInfo: hInfo)
                                    //.opacity(0)
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    
                }
                Spacer()
                
            }
        }
    }
}
