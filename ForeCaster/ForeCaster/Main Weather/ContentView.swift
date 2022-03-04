//
//  ContentView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 2/24/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            WeatherView()
                .tabItem{
                    Label("Weather", systemImage: "cloud")
                }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear")
                }
            TaskListView()
                .tabItem{
                    Label("Notifications", systemImage: "bell")
                }
        }

    }
}


