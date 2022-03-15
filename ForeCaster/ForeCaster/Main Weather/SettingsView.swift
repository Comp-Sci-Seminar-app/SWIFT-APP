//
//  SettingsView.swift
//  ForeCaster
//
//  Created by Ari Bredbenner (student LM) on 2/24/22.
//

import SwiftUI

struct SettingsView: View {
    @State var reminderEnabled: Bool = true
    @State var selectedTrigger = ReminderType.time
    @State var timeDurationIndex: Int = 0
    @State private var shouldRepeat = true
    @Environment(\.presentationMode) var presentationMode
    @StateObject var locationManager = LocationManager()
    
    let timeDurations: [Int] = Array(1...60)
    func makeReminderTime(time: Int) -> Reminder? {
        guard reminderEnabled else {
            return nil
        }
        timeDurationIndex = time
        var reminder = Reminder()
        reminder.reminderType = selectedTrigger
        reminder.timeInterval = TimeInterval(timeDurations[timeDurationIndex] * 60)
        reminder.repeats = true
        return reminder
    }
    
    @State var selectedTriggerCalendar = ReminderType.calendar
    @State private var dateTrigger = Date()
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var radius: String = ""
    
    
    func makeReminderCalendar() -> Reminder? {
        guard reminderEnabled else {
            return nil
        }
        var reminder = Reminder()
        reminder.reminderType = selectedTrigger
        reminder.date = dateTrigger
        reminder.repeats = false
        return reminder
    }
    
    
    
    var body: some View{
        VStack{
            Toggle(isOn: $reminderEnabled) {
                Text("Add Reminder")
            }
            .padding(.vertical)
 
            Button("Create 1 minute notification") {
                TaskManager.shared.addNewTask("1 minute notification", makeReminderTime(time: 0))
                presentationMode.wrappedValue.dismiss()
            }
            
            Button("Create 2 minute notification") {
                TaskManager.shared.addNewTask("2 minute notification", makeReminderTime(time: 1))
                presentationMode.wrappedValue.dismiss()
            }
            
            Button("Test Date Based") {
                TaskManager.shared.addNewTask("n", makeReminderCalendar())
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
