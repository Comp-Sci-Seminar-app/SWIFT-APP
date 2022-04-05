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
    
    var body: some View {
        let allHourly = g.hForecast.properties.periods
        VStack {
            ScrollView{
                Spacer()
                Toggle(isOn: $twentyFourHourClock, label: {Text("24 Hour time?")})
                Button("Request Permission") {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("All set!")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }.buttonStyle(NeumorphicButtonStyle(bgColor: Color.gray))
                
                Spacer()
                TextField("Keyword to check for notifications: ", text: $keyWord)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).opacity(0.8)
                
                Text("You know those short forcasts for hours? If you enter a word in here and create notifications, this will search through every hour loaded and create a notification for each one.").background(Color.customBlue.opacity(0.6)).cornerRadius(10)
                Spacer().frame(height: 10)
                Text("Note: this will create notifications for today going into a week from now. you can delete them at any time. Also this will change your time to 24 hour time. ").background(Color.customBlue.opacity(0.6)).cornerRadius(10)
                
                VStack{
                    Spacer()
                    Button("Schedule Notification") {
                        twentyFourHourClock = true
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                        
                        for i in returnHourList(hp: allHourly){
                            let content = UNMutableNotificationContent()
                            content.title = "Weather Notification"
                            content.subtitle = "Rain"
                            content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 100.0)
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i), repeats: false)
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request)
                            print("\(i)")
                        }
                        
                    }.buttonStyle(NeumorphicButtonStyle(bgColor: Color.customBlue))
                    Spacer()
                    Button("Remove Notifications") {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    }.buttonStyle(NeumorphicButtonStyle(bgColor: Color.customBlue))
                    Spacer()
                }
            }
        }.background(
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
    }
}

