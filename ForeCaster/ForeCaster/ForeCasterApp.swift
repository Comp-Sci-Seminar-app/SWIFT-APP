//
//  ForeCasterApp.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 2/24/22.
//
import CoreLocation
import SwiftUI



@main
struct ForeCasterApp: App {
    @ObservedObject var locationManager = LocationManager.shared
    @AppStorage("customLocations")
    private var customLocations: Data = Data()
    
    var body: some Scene {
        
        
        WindowGroup {
            SettingsView()
            /*
            if let local = try? JSONDecoder().decode([customLocation].self, from: customLocations){
                if locationManager.userLocation != nil || local.count > 1{
                    ContentView()
                }
                else{
                    LocationRequestView()
                }
            }
            else{
                if locationManager.userLocation != nil{
                    ContentView()
                }
                else{
                    LocationRequestView()
                }
            }
            */
        }
    }
}
