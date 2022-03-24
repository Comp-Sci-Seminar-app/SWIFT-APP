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
        ZStack{
            VStack{
                Spacer().frame(height: 60)
                Text("\(dayInfo.detailedForecast)").background(Color.gray.opacity(0.6)).cornerRadius(7).frame(width: UIScreen.main.bounds.width - 60)
                Spacer()
                
                ScrollView(){
                    VStack{
                        Spacer().frame(height: 10)
                        VStack{
                            Text("Wind Speed:")
                            Text("\(dayInfo.windSpeed) mph")
                        }.frame(width: UIScreen.main.bounds.width - 50, height: 80).background(Color.customBlue.opacity(0.6)).cornerRadius(10)
                        
                        Spacer().frame(height: 10)
                        VStack{
                            Text("Temperature:")
                            Text("\(dayInfo.temperature) mph")
                        }.frame(width: UIScreen.main.bounds.width - 50, height: 80).background(Color.customBlue.opacity(0.6)).cornerRadius(10)
                        
                        Spacer().frame(height: 10)
                        VStack{
                            Text("Wind Direction:")
                            Text("\(dayInfo.windSpeed) mph")
                        }.frame(width: UIScreen.main.bounds.width - 50, height: 80).background(Color.customBlue.opacity(0.6)).cornerRadius(10)
                        
                        Spacer().frame(height: 10)
                    }.font(.system(size: 25))
                }.frame(height: 280)
                
                Spacer()
                ScrollView(.horizontal){
                    Group{
                        if index == 1{
                            
                            HStack{
                                ForEach(0..<getHowManyHoursAreLeftInToday()){i in
                                    
                                    NavigationLink(destination: AdvancedHourlyView(data: hInfo[i]), label: {hourlyPreView(i:i, hInfo: hInfo)})
                                    //hourlyPreView(i:i, hInfo: hInfo)
                                    //.opacity(0)
                                    Spacer()
                                }
                                
                            }
                        }
                        
                        else if index == 6{
                            HStack{
                                ForEach((getHowManyHoursAreLeftInToday() + 120)..<hInfo.count){i in
                                    NavigationLink(destination: AdvancedHourlyView(data: hInfo[i]), label: {hourlyPreView(i:i, hInfo: hInfo)})
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
                                    NavigationLink(destination: AdvancedHourlyView(data: hInfo[i]), label: {hourlyPreView(i:i, hInfo: hInfo)})
                                    //.opacity(0)
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    
                }
                Spacer().frame(height: 100)

                
            }
            VStack{
                Spacer().frame(height: 27.5)
                HStack{
                    Rectangle().frame(width: 80, height: 30).opacity(0.6).cornerRadius(20)
                    Spacer()
                }
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).ignoresSafeArea(.all)
        .background(Image("background")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .ignoresSafeArea(.all)
                        
        )
        
        
    }
}
