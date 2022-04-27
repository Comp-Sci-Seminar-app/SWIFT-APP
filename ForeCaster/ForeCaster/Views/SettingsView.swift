//
//  SettingsView.swift
//  ForeCaster
//
//  Created by Ari Bredbenner (student LM) on 2/24/22.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var g = Decoded()// new API
    @StateObject var f = FetchData()// old API
    @AppStorage("24h") var twentyFourHourClock : Bool = false
    @AppStorage("keyword") var keyWord : String = "Rain"
    @State var hourOffest : HourOffsetList = HourOffsetList.Zero
    @State private var showingSheet = false
    @State private var showingIdeal = false
    var body: some View {
        let allHourly = g.hForecast.properties.periods
        VStack {
            ScrollView{
                
                
                VStack{
                    Spacer().frame(height: 30)
                    Toggle(isOn: $twentyFourHourClock, label: {Text("24 Hour time?")})
                    
                    Spacer()
                    //do I really need comments for this?
                    Button("Change Location") {
                        showingSheet.toggle()
                    }.buttonStyle(NeumorphicButtonStyle(bgColor: Color.gray))
                    Spacer()
                    //pulls up the ideal hour menue
                    Button("Find ideal Hours") {
                        showingIdeal.toggle()
                    }.buttonStyle(NeumorphicButtonStyle(bgColor: Color.gray))
                    Spacer()
                }
                VStack{
                    //gets permission, strangely not required for ipad
                    Button("Request Notification Permission") {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                print("All set!")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }.buttonStyle(NeumorphicButtonStyle(bgColor: Color.gray))
                    Spacer()
                    
                    //schedules the notifications
                    Button("Schedule Notification") {
                        
                        //iterates through the list of correct hours and gives the notifications
                        for i in returnHourList(hp: allHourly){
                            let content = UNMutableNotificationContent()
                            content.title = "Weather Notification"
                            content.subtitle = keyWord
                            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(keyWord).mp3"))
                            var modifiableI = i
                            if ((i - hourOffest.rawValue) > 0){
                                modifiableI -= hourOffest.rawValue
                            }
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(modifiableI), repeats: false)
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request)
                            print("\(i)")
                        }
                        
                    }.buttonStyle(NeumorphicButtonStyle(bgColor: Color.customBlue))
                    Spacer()
                    
                    //you know what this does
                    Button("Remove Notifications") {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    }.buttonStyle(NeumorphicButtonStyle(bgColor: Color.customBlue))
                    Spacer()
                    //what word the user should use
                    TextField("Keyword to check for notifications: ", text: $keyWord)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle()).opacity(0.8)
                    //explanation for the stupid
                    Text("You know those short forcasts for hours? If you enter a word in here and create notifications, this will search through every hour loaded and create a notification for each one.").background(Color.customBlue.opacity(0.6)).cornerRadius(10).fixedSize(horizontal: false, vertical: true)

                    Spacer().frame(height: 10)
                    Text("Note: this will create notifications for today going into a week from now. you can delete them at any time.").background(Color.customBlue.opacity(0.6)).cornerRadius(10).fixedSize(horizontal: false, vertical: true)
                                     
                }
                Spacer().frame(height: 60)
                Image("down").resizable().frame(width: 100, height: 100).overlay(
                    RoundedRectangle(cornerRadius: 15.0)
                        .stroke(lineWidth: 2.0)
                        .foregroundColor(Color.yellow))
                Spacer().frame(height: 60)
                //hour offset
                Text("This sets how much earlier you want the notification. Note: if your offset makes the notification happen negative hours from now, it will be disregarded").background(Color.customBlue.opacity(0.6)).cornerRadius(10)
                Picker("", selection: $hourOffest){
                    Text("None").tag(HourOffsetList.Zero)
                    Text("One").tag(HourOffsetList.One)
                    Text("Two").tag(HourOffsetList.Two)
                    Text("Three").tag(HourOffsetList.Three)
                    Text("Four").tag(HourOffsetList.Four)
                    Text("Five").tag(HourOffsetList.Five)
                }.background(Color.customBlue.opacity(0.6)).cornerRadius(10)
                Spacer()
            }
        }.edgesIgnoringSafeArea(.all).background(
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
            
        )//holy sheet!
        .sheet(isPresented: $showingSheet){
            LocationRequestView(showSheet: $showingSheet)
        }
        .fullScreenCover(isPresented: $showingIdeal){
            idealTempModleView().opacity(0.8).frame(width:UIScreen.main.bounds.width).ignoresSafeArea(.all)
        }
    }
}

