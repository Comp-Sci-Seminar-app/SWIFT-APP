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






func makeTimeNice(_ evilTime: String)-> String{//Changes the time from what it looks like in the API(below) to normal format
    //2022-02-24T10:00:00-05:00(example)
    @AppStorage("24h") var twentyFourHourClock : Bool = false
    let start = evilTime.dropFirst(11)//Removes the first 11 chars: 10:00:00-05:00
    let end = start.dropLast(9)//Removes the last 9 chars: 10:00
    var niceTime = String(end)//converts substring to string
    if niceTime.first == "0"{//checks if first char is a 0, for example 4:00 AM would be 2022-02-24T04:00:00-05:00 in the API and at this point would be 04:00
        niceTime = String(niceTime.dropFirst())//removes the 0: 4:00
    }
    else if !twentyFourHourClock{//Checks type of time for user
        for i in 13...24{//iterates through 13 and 24
            if niceTime.hasPrefix(String(i)){//checks if first two chars of time are greater than 12, the API uses a 24 hour clock
                return String(i-12)+String(niceTime.dropFirst(2))+" PM"//removes the first two chars, replaces them with their 12 hour clock version, and returns the value
            }
        }
    }
    if !twentyFourHourClock{
        return niceTime+" AM"//adds AM to end of hours no over 12 in API if user selects 12 hour clock
    }
    else{
        return niceTime//returns the shortened time in the default 24 hour clock format
    }
}

func positiveOnly(_ num : Double)->Double{//Takes a double and returns it if possitive, or zero if negative. Used so the screen doesn't go white if you scroll up
    if num > 0 {
        return num
    }
    else{
        return 0.0
    }
}


//found this stuff from github, gonna go through and figure it out in a bit (Today is March 2nd)
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
        //print("value = \(value)")
    }
    
    typealias Value = CGPoint
    
}

struct ScrollViewOffsetModifier: ViewModifier {
    let coordinateSpace: String
    @Binding var offset: CGPoint
    
    func body(content: Content) -> some View {
        ZStack {
            content
            GeometryReader { proxy in
                let x = proxy.frame(in: .named(coordinateSpace)).minX
                let y = proxy.frame(in: .named(coordinateSpace)).minY
                Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: CGPoint(x: x * -1, y: y * -1))
            }
        }
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            offset = value
        }
    }
}

extension View {
    func readingScrollView(from coordinateSpace: String, into binding: Binding<CGPoint>) -> some View {
        modifier(ScrollViewOffsetModifier(coordinateSpace: coordinateSpace, offset: binding))
    }
}
//Everything below is my work

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var g = Decoded()// new API
    @StateObject var f = FetchData()// old API
    @State var displayCurrentHours = false//Used in old app, probably gonna delete
    @State var displayTommorrowHours = false//this too
    @State var displayDayAfter = false//this too
    @State var offset: CGPoint = .zero// this is the offset of the scroll view
    @State var coeffOfWidth = (UIScreen.main.bounds.width/2)-73
    @State private var showingSheet = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
                
                    ZStack {//so i can put a rectangle as the background and stuff like that
                        //for the background
                        ZStack{
                            
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
                                
                                
                                ScrollView(.horizontal, showsIndicators: false) {//scrollview with the actual info
                                    //Spacer().frame(width: 100, height: heightOffset, alignment: .center)
                                    HStack{//the actual info
                                        Spacer().frame(width: 5)//Keeps the blocks off the side of the screen and looks 100x better
                                        ForEach(0..<allDaily.count){index in//goes through all the info
                                            VStack{//one block containing text in the horizontal scrollview
                                                
                                                Text(allDaily[index].name).foregroundColor(.white)
                                                Text(" \(Image(systemName: "thermometer")) \(allDaily[index].temperature) \(allDaily[index].temperatureUnit) ").foregroundColor(.white)
                                                Text(" \(Image(systemName: "wind")) \(allDaily[index].windSpeed) \(allDaily[index].windDirection) ").foregroundColor(.white)
                                                //Text("Forecast: \(allDaily[index].detailedForecast)").multilineTextAlignment(.center).frame(width: 40)
                                            }.background(Color.blue.opacity(0.5))
                                            .cornerRadius(10)
                                            .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)//makes it look nice
                                            Spacer()//keeps the blocks seperate
                                        }
                                    }
                                    
                                }.readingScrollView(from: "scroll", into: $offset)//idk abt this
                                Spacer().frame(width: 100, height: 100, alignment: .center)//makes space between views
                                ScrollView(.horizontal, showsIndicators: false) {//same exactly as above, only change is its hourly
                                    //Spacer().frame(width: 100, height: heightOffset, alignment: .center)
                                    HStack{
                                        Spacer().frame(width: 5)
                                        ForEach(0..<allHourly.count){index in
                                            NavigationLink(destination: AdvancedHourlyView(data: $g.hForecast.properties.periods[index])) {
                                                VStack{
                                                    
                                                    Text(" \(makeTimeNice(allHourly[index].startTime)) ").foregroundColor(.white)//this gets the time, thats the only real difference other than the actual values
                                                    Text(" \(Image(systemName: "thermometer")) \(allHourly[index].temperature) \(allHourly[index].temperatureUnit) ").foregroundColor(.white)
                                                    if !(allHourly[index].windSpeed.hasPrefix("0")){
                                                        Text(" \(Image(systemName: "wind")) \(allHourly[index].windSpeed) \(allHourly[index].windDirection) ").foregroundColor(.white)
                                                    }
                                                    else{
                                                        Text(" \(Image(systemName: "wind")) 0 mph ").foregroundColor(.white)
                                                    }
                                                    //Text("Forecast: \(allDaily[index].detailedForecast)").multilineTextAlignment(.center).frame(width: 40)
                                                }.background(Color.blue.opacity(0.5))
                                                .cornerRadius(10)
                                                .frame(alignment: .center)
                                                //.opacity(0)
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                    
                                }
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//FAR from the best way to do it, but its how im gonna do it so fight me!
func timeToInt(_ rawTime : String) -> Int {
    let tTime0 : String = String(rawTime[rawTime.lastIndex(of: " ")!...])
    let tTime : String = String(tTime0.dropFirst())
    let tTime2 : String = String(tTime[...tTime.firstIndex(of: ":")!])
    let tTime3 : String = String(tTime2.dropLast())
    let time = Int(tTime3) ?? 0
    return time
}
