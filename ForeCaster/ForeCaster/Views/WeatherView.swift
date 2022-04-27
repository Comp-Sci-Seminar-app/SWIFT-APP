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

struct WeatherView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var g = Decoded()// new API
    @StateObject var f = FetchData()// old API
    @State var offset: CGPoint = .zero// this is the offset of the scroll view
    @State var coeffOfWidth = (UIScreen.main.bounds.width/2)-73
    @AppStorage("locationRequest") private var showingSheet = true
    @State var loadingDissapear = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var progressMove = 0
    @State var totalWait : Double = 0
    
    
    //@AppStorage("customLocations") private var customLocations: Data = Data()
    
    
    
    let hoursLeft = getHowManyHoursAreLeftInToday()
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        // let local = try? JSONDecoder().decode([customLocation].self, from: customLocations)
        
        let screenHeight = UIScreen.main.bounds.height
        
        
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
                                Text("Current temperature: \(Int(f.responses.current.temp_f.rounded()))")
                                Text("Current Weather: \(f.responses.current.condition?.text ?? "no data yet")")
                            }.font(.system(size: 20))
                            Image("wireframe").resizable().frame(width: 50, height: 50)
                        }.frame(width: UIScreen.main.bounds.width - 10, height: 70).background(Color.customBlue.opacity(0.6)).cornerRadius(20)
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
                                        
                                    }.frame(width: UIScreen.main.bounds.width - 10, height: 130).background(Color.customBlue.opacity(0.5))
                                    .cornerRadius(10)
                                    .frame(alignment: .center).font(.system(size: 30))
                                    
                                    
                                })
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                                //makes it look nice
                                
                                
                                Spacer()//keeps the blocks seperate
                            }
                            Spacer().frame(height: 40)
                            
                            
                            
                            
                            
                            
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
                                    .edgesIgnoringSafeArea(.all)
                                
                                //if it is night, uses a different image
                            }else{
                                Image("night")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .edgesIgnoringSafeArea(.all)
                                
                            }
                        }
                        
                    )
                    ZStack{
                        Rectangle().fill(Color(.systemBlue))//the background, covers the UI behind
                            .edgesIgnoringSafeArea(.all)
                            .brightness(0.3)
                        Image("FCLogo").resizable()//our logo, so the loading screen looks cool
                            .frame(width: 200, height: 200, alignment: .center)//sizes the logo to fit the best possible
                            .position(x: screenWidth/2, y: screenHeight/2)//positions the logo in the center of the screen
                        VStack{
                            
                            Text("Welcome to Forecaster")
                            
                            
                            ProgressView("Loading...", value: Float(progressMove), total: 100).progressViewStyle(GaugeProgressStyle())//creates the progress view
                                .onReceive(timer) { _ in//goes through below code when the time publishes (every 0.1 seconds)
                                    
                                    if progressMove < 100{//checks so progressMove doesnt infinitly grow
                                        if g.weather.properties.forecast == "load" && progressMove < 50{//checks if the 1st json has given data
                                            progressMove += 1//increases the progress by 1%
                                            
                                        }
                                        else if g.dForecast.properties.periods[0].name != "load" && progressMove < 50{//checks if the data has been recived
                                            progressMove = 50//jumps progress bar to 50% to prevent unnecessary loading time
                                        }
                                        if f.responses.location.localtime == "2022-01-04 7:58" && progressMove <= 100{//checks if the 2nd json has given data
                                            progressMove += 1//increases the progress by 1%
                                        }
                                        else if f.responses.location.localtime != "2022-01-04 7:58" && progressMove <= 100{//checks if the data has been recived
                                            progressMove = 100//finishes the loading to prevent waiting
                                        }
                                    }
                                }
                                .position(x: screenWidth/2, y: screenHeight/2-30)//positions it around the logo
                            if totalWait > 20{
                                Text("Loading error, please restart app \(g.dForecast.properties.periods[0].name)")//if it takes over 20 seconds to load tells the user to restart the app
                            }
                        }
                    }.opacity(1-loadingDissapear)//changes the opacity to fade load screen out
                    .onReceive(timer, perform: { _ in//every time the timer publishes it goes through this
                        if progressMove >= 100 && g.dForecast.properties.periods[0].temperature != 1000{//checks if the bar is full and the json had given some data
                            loadingDissapear += 0.2//increases this so it slowly dissapears
                        }
                        else{
                            totalWait += 0.1//if it hasnt loaded or gotten information it adds to the wait time
                        }
                    })
                    
                }
                
                
            }
            
            
            
        }.sheet(isPresented: $showingSheet){
            LocationRequestView(showSheet: $showingSheet)
        }.navigationBarTitle("").navigationBarHidden(true).navigationViewStyle(StackNavigationViewStyle())
        
        
    }
}
