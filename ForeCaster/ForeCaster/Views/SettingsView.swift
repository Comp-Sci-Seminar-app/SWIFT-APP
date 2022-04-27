//
//  SettingsView.swift
//  ForeCaster
//
//  Created by Samuel Conry-Murray (student LM) on 3/25/22.
//

import SwiftUI

struct SettingsView: View {
    
    @State var boolean = true
    @AppStorage("customLocations") private var customLocations: Data = Data()
    @AppStorage("24HourClock") var twentyFourHourClock : Bool = false
    
    var body: some View {
        
        NavigationView{
            VStack{
                Spacer()
                Toggle("24 Hour Clock", isOn: $twentyFourHourClock)
                NavigationLink(
                    destination: LocationManagerView(),
                    label: {
                        
                        Text("Manage Locations")
                            .frame(width: 150, height: 30, alignment: .center)
                            .background(Color.black.brightness(0.3))
                            .cornerRadius(20)
                        
                        
                    })
                Spacer()
            }.background(Color.blue)
            .edgesIgnoringSafeArea(.all)
        }.edgesIgnoringSafeArea(.all)
        
    }
}


struct LocationManagerView: View{
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @AppStorage("locationAdded") var locationAdded : Bool = false
    @AppStorage("customLocations") var customLocations: Data = Data()
    @AppStorage("WhatLocationAreYouUsing") var name : Int!
    @State var showSheet : Bool = false
    @State private var newNickname : String = ""
    @State var selectedLocations : Int = 0
    @ObservedObject var locationManager = LocationManager.shared
    
    
    var body: some View{
        
        
        
        ZStack{
            Rectangle().fill(Color.blue)
                .edgesIgnoringSafeArea(.all)
            VStack{
                if locationManager.userLocation != nil{
                    Text("Current Location")
                        .foregroundColor(.black)
                        .background(Color.black.brightness(0.60))
                        
                        
                }
                if  (try? JSONDecoder().decode([customLocation].self, from: customLocations)) != nil{
                    
                    let local = (try? JSONDecoder().decode([customLocation].self, from: customLocations))
                    if local![0].address != nil {
                        
                        Text("Locations")
                        ForEach(0..<local!.count) { i in
                            
                            if let nickname = local![i].nickname{
                                Text("\(nickname)").foregroundColor(.black)
                            }
                            
                            else{
                                HStack{
                                    TextField("Nickname", text: $newNickname).foregroundColor(.black)
                                        .background(Color.black.brightness(0.60))
                                    Button(action: {
                                        local![i].nickname = newNickname
                                    }, label: {
                                        Text("Add Nickname").frame(width: 150, height: 30, alignment: .center)
                                            .background(Color.black.brightness(0.3))
                                            .cornerRadius(20)
                                    })
                                }
                                
                            }
                            //                        if let address = local[i].oneLineAddress{
                            //                            Text("Address: \(address)")
                            //                        }
                        }
                    }
                    else{
                        Text("No Stored Locations Found")
                    }
                }
                if locationManager.userLocation == nil{
                    Button(action: {
                        name = 0
                    }, label: {
                        Text("Use Current Location")
                    })
                }
                else{
                    Text("No Stored Locations Found")
                }
                Button("Add Location") {
                    showSheet.toggle()
                }.frame(width: 120, height: 20, alignment: .center)
                .background(Color(red: 72/225, green: 72/225, blue: 72/225))
                .cornerRadius(20)
                .foregroundColor(.white)
                .sheet(isPresented: $showSheet) {
                    NewLocationView(redirectBack: true)
                }
                .onReceive(timer, perform: { _ in
                    if locationAdded{
                        showSheet = false
                        locationAdded = false
                    }
                })
                
                
            }
            
            
        }
        
        
    }
}

