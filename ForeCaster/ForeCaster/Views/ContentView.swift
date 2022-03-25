//
//  ContentView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 2/24/22.
//

import SwiftUI
//Placeholder till its implemented in settings as appstorage

import UIKit
import CoreLocation


//Everything below is my work

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var g = Decoded()// new API
    @StateObject var f = FetchData()// old API
    @State var offset: CGPoint = .zero// this is the offset of the scroll view
    @State var coeffOfWidth = (UIScreen.main.bounds.width/2)-73
    @State private var showingSheet = true
    
    
    let hoursLeft = getHowManyHoursAreLeftInToday()
    init(){
        // Theme.navigationBarColors(background: .clear, titleColor: .clear)
    }
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        //let screenHeight = UIScreen.main.bounds.height
        
        
        //let screenOffset =
        let allDaily = g.dForecast.properties.periods//all of the important info passed by the API for daily
        let allHourly = g.hForecast.properties.periods//all of the important info passed by the API for hourly
        let heightOffset = 90+offset.y//the normal offset is 90 off because of how spacers work in scrollviews, this makes it easier to use the value
        let dayOffset: Int = nightOrDay(dp: allDaily[2])
        NavigationView{
            
            Group{
                
                ZStack {
                    //so i can put a rectangle as the background and stuff like that
                    //for the background
                    VStack{
                        Spacer().frame(height: 40)
                        HStack{
                            VStack{
                                Text("Current temperature: \(f.responses.current.temp_f)")
                                Text("Current Weather: \(f.responses.current.condition?.text ?? "no data yet")")
                            }.font(.system(size: 20))
                            Image("wireframe").resizable().frame(width: 50, height: 50)
                        }.frame(width: UIScreen.main.bounds.width - 10, height: 70).background(Color.blue.opacity(0.6)).cornerRadius(20)
                        Spacer()
                        ScrollView(showsIndicators: false) {
                            //scrollview with the actual info
                            //the actual info
                            Spacer().frame(width: 5)//Keeps the blocks off the side of the screen and looks 100x better
                            
                            ForEach(1..<7){index in//goes through all the info
                                
                                NavigationLink(destination: DailyView(dayInfo : allDaily[(index * 2) - dayOffset] , hInfo : allHourly , index: index ), label: {
                                    VStack{//one block containing text in the horizontal scrollview
                                        
                                        Text(allDaily[(index * 2) - dayOffset].name).foregroundColor(.white)
                                        Text(" \(Image(systemName: "thermometer")) \(allDaily[(index * 2) - dayOffset].temperature) \(allDaily[(index * 2) - dayOffset].temperatureUnit) ").foregroundColor(.white)
                                        Text(" \(Image(systemName: "wind")) \(allDaily[(index * 2) - dayOffset].windSpeed) \(allDaily[(index * 2) - dayOffset].windDirection) ").foregroundColor(.white)
                                        //Text("Forecast: \(allDaily[index].detailedForecast)").multilineTextAlignment(.center).frame(width: 40)
                                    }.frame(width: UIScreen.main.bounds.width - 10, height: 130).background(Color.blue.opacity(0.5))
                                    .cornerRadius(10)
                                    .frame(alignment: .center).font(.system(size: 30))
                                    
                                    
                                }).navigationBarTitle("Back").navigationBarHidden(true)
                                //makes it look nice
                                
                                
                                Spacer()//keeps the blocks seperate
                            }
                            
                            
                            
                            
                            
                            
                        }.ignoresSafeArea(.all)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(
                        Group{
                            //checks if it is night
                            if (timeToInt(f.responses.location.localtime) < 19 && timeToInt(f.responses.location.localtime) > 5){
                                Image("\(f.responses.current.condition?.code ?? 1000)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                
                                //if it is night, uses a different image
                            }else{
                                Image("night")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                        
                    )
                    .sheet(isPresented: $showingSheet){
                        LocationRequestView(showSheet: $showingSheet)
                    }
                    
                    
                }
                
                
                
            }
        }.navigationBarTitle("").navigationBarHidden(true)
        
        
    }
}
