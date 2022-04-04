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
        }

    }
}


