//
//  LocationRequestView.swift
//  ForeCaster
//
//  Created by Samuel Conry-Murray (student LM) on 3/7/22.
//

import SwiftUI

struct LocationRequestView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @AppStorage("allowLocation") var allowLocation : Bool = true
    @AppStorage("customLocations")private var customLocations: Data = Data()
    @AppStorage("WhatLocationAreYouUsing") var name : Int!
    var body: some View {
        
        Group{
            if(locationManager.userLocation == nil && allowLocation){
        ZStack{
            Color(.systemBlue).ignoresSafeArea()
            VStack{
                Spacer()
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("Allow access to location")
                Text("Locations can be entered manualy without location services")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
                
                
                Spacer()
                
                
                VStack{
                    Button(action: {
                        LocationManager.shared.requestLocation()
                        print("It did it")
                        allowLocation.toggle()
                        name = 0
                        //ContentView()
                    }, label: {
                        Text("Allow Access").frame(width:120)
                    }).padding()
                    .background(Color.blue)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    Button(action: {
                        NewLocationView(redirectBack: false)
                        print("L")
                        allowLocation = false
                        
                    }, label: {
                        Text("Deny").frame(width: 120)
                    }).padding()
                    .background(Color.blue)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    
                    
                }
                Spacer()
            }.foregroundColor(.white)
        }
            }
            else if !allowLocation && locationManager.userLocation != nil{
                ContentView()}
            else{
                NewLocationView(redirectBack: false)}
        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
