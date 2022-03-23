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
        Theme.navigationBarColors(background: .clear, titleColor: .clear)
    }
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        //let screenHeight = UIScreen.main.bounds.height
        
        
        //let screenOffset =
        let allDaily = g.dForecast.properties.periods//all of the important info passed by the API for daily
        let allHourly = g.hForecast.properties.periods//all of the important info passed by the API for hourly
        let heightOffset = 90+offset.y//the normal offset is 90 off because of how spacers work in scrollviews, this makes it easier to use the value
        NavigationView{
            Group{
                // if locationManager.userLocation == nil{
                //      LocationRequestView()
                //  }
                
                ZStack {
                    //so i can put a rectangle as the background and stuff like that
                    //for the background
                    VStack{
                        
                        ScrollView(showsIndicators: false) {
                            //scrollview with the actual info
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
                            //Spacer().frame(width: 100, height: heightOffset, alignment: .center)

                            
                            
                            
                            
                        }
                        //.readingScrollView(from: "scroll", into: $offset)//idk abt this
                        Spacer().frame(width: 100, height: 100, alignment: .center)//makes space between views
                        Spacer().frame(width: 100, height: 100, alignment: .center)//makes space between views
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
                    .edgesIgnoringSafeArea(.all)
                    .brightness(0.2-positiveOnly(Double(heightOffset)/300))
                    .sheet(isPresented: $showingSheet){
                        LocationRequestView(showSheet: $showingSheet)
                    }
                    
                    
                    VStack{
                        Spacer().frame(width: 100, height: 25, alignment: .center)//Spacer so the text isnt covered by the scrolling stuff
                        ScrollView(showsIndicators: false){//scrollview being tracked
                            Spacer().frame(width: 100, height: 90, alignment: .center)//keeps the scrollview from going on top of the moving text
                            
                            
                            ScrollView(showsIndicators: false) {//scrollview with the actual info
                                //Spacer().frame(width: 100, height: heightOffset, alignment: .center)
                                VStack{//the actual info
                                    Spacer().frame(width: 5)//Keeps the blocks off the side of the screen and looks 100x better
                                    //goes through all the info
                                    
                                }
                                
                            }.readingScrollView(from: "scroll", into: $offset)//idk abt this
                            Spacer().frame(width: 100, height: 100, alignment: .center)//makes space between views
                            Spacer()
                                .frame(height: 2000)//for demonstration
                            Text("You can't scroll any more sorry")
                                .foregroundColor(.white)//for the lols
                        }
                        .coordinateSpace(name: "scroll")//not sure about this either
                    }
                    
                    VStack{//Contains the text that is being changed
                        Spacer().frame(height: 5)
                        ZStack{
                            DIssapearingView(data: f.responses.current)
                                .opacity(1-(Double(heightOffset)/85))
                                .foregroundColor(.white)//slowly dissapears as user scrolls
                            //Spacer()
                            AppearingView(data: f.responses.current)
                                .opacity(0+(Double(heightOffset)/85))
                                .foregroundColor(.white)
                        }
                        
                        
                        //      if heightOffset < 87{//keeps on screen till it reaches the point that i want it to stop at
                        //           Text("This text is moving")
                        //               .position(x: 73+CGFloat(positiveOnly(Double(heightOffset))*(Double(coeffOfWidth)/87)), y:60-CGFloat(positiveOnly(Double(heightOffset)))).foregroundColor(.white)//moves with the scrolling
                        //       }
                        //       if heightOffset >= 87{//makes the text appear in place of the other at the point i want it
                        //            Text("This text is moving").position(x: (screenWidth/2), y: -28).foregroundColor(.white)//puts the same text as above in the same spot
                        //        }
                        
                        
                        // Text("\(heightOffset)").foregroundColor(.white)//used for figuring out values for stuff
                        Spacer()
                    }
                }
                
                //.edgesIgnoringSafeArea(.all)//fills out the screen
                
            }
        }
    }
}
