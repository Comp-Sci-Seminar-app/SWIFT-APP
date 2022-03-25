//
//  backend.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 3/2/22.
//

import SwiftUI
import UIKit
import CoreLocation


//allows me to set the back button to invisible so I can add a custom image behind it. Also copy and pasted from stack overflow

class Theme {
    static func navigationBarColors(background : UIColor?,
                                    titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .black
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}
extension Color{
    static let customBlue = Color("CustomBlue")
    static let customGray = Color("CustomGray")
    
}





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


//FAR from the best way to do it, but its how im gonna do it so fight me!
func timeToInt(_ rawTime : String) -> Int {
    let tTime0 : String = String(rawTime[rawTime.lastIndex(of: " ")!...])
    let tTime : String = String(tTime0.dropFirst())
    let tTime2 : String = String(tTime[...tTime.firstIndex(of: ":")!])
    let tTime3 : String = String(tTime2.dropLast())
    let time = Int(tTime3) ?? 0
    return time
}

//figuring out how many hours to display for today
func getHowManyHoursAreLeftInToday() -> Int{
    let date = Date()
    var calendar = Calendar.current
    let hour = calendar.component(.hour, from: date)
    return 25-hour
}


func nightOrDay(dp: DPeriods) -> Int{
    if (dp.name.contains("Night")){
        return 1
    }
    
    
    return 2
}


