//
//  SettingsView.swift
//  ForeCaster
//
//  Created by Ari Bredbenner (student LM) on 2/24/22.
//

import SwiftUI

struct SettingsView: View {
    @State var reminderEnabled: Bool = false
        @State var selectedTrigger = ReminderType.time
        @State var timeDurationIndex: Int = 0
        @State private var shouldRepeat = true
        @Environment(\.presentationMode) var presentationMode
        
        @StateObject var locationManager = LocationManager()
        
        func makesReminder() -> Reminder? {
            guard reminderEnabled else {
                return nil
            }
            var reminder = Reminder()
            reminder.timeInterval = TimeInterval(1)
            reminder.repeats = shouldRepeat
            return reminder
        }
        
        var body: some View{
            
            Button("Create 1 minute notification") {
                TaskManager.shared.addNewTask("1 minute notification", makesReminder())
                presentationMode.wrappedValue.dismiss()
            }
        }

}
