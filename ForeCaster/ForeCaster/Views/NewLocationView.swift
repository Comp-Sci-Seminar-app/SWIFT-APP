//
//  NewLocationView.swift
//  ForeCaster
//
//  Created by Samuel Conry-Murray (student LM) on 3/8/22.
//

import SwiftUI


struct NewLocationView: View {
    @State var oneLineAddress : String = ""
    @State var zipCode : String = ""
    @State var city : String = ""
    @State var state : String = ""
    @State var nickname : String = ""
    var redirectBack : Bool
    @AppStorage("customLocations") var customLocations: Data = Data()
    @State var locationList = [customLocation("", nickname: "", number: 0)]
    @AppStorage("locationAdded") var locationAdded : Bool = false
    @AppStorage("WhatLocationAreYouUsing") var name : Int!
    var body: some View {
        Group{
            if !locationAdded{
            VStack{
                
                VStack{
                    Text("Enter Address").font(.title)
                    Spacer().frame(height: 40)
                    TextField("Address",
                              text: $oneLineAddress).accentColor(.white)//Reads in address
                    Text("Use street abriviation i.e. Avenue -> Ave").font(.footnote)//for user
                    TextField("ZIP Code",
                              text: $zipCode)
                            .accentColor(.white)
                            .keyboardType(.numberPad)//reads in zip code
                    TextField("City",
                              text: $city).accentColor(.white)
                        .disableAutocorrection(true)//reads in city
                    TextField("State",
                              text: $state).accentColor(.white)
                        .disableAutocorrection(true)//reads in state
                    Text("Use state abriviation i.e. New York -> NY").font(.footnote)//for user
                    TextField("Nickname (Optional)", text: $nickname).accentColor(.white)//reads in optional nickname
                }
                Spacer()
                Button(action: {//Stores entered values in appstorage to be used in perpetuity accross the app
                    if nickname != ""{//Checks if a nickname was entered for the location
                        locationList.append(customLocation(address: URlForm(oneLineAddress, city: city, state: state, zip: zipCode), oneLineAddress: "\(oneLineAddress) \(city) \(state) \(zipCode)", nickname: nickname, number: locationList.count+1))//adds the entered info to the list of locations
                        guard let locationData = try? JSONEncoder().encode(locationList) else{return}//encodes the list of locations as JSON
                        customLocations = locationData//sets the encoded list equal to the appstorage thing
                    }
                    else{//does the same as above but without the address
                        locationList.append(customLocation(address: URlForm(oneLineAddress, city: city, state: state, zip: zipCode), oneLineAddress: "\(oneLineAddress) \(city) \(state) \(zipCode)", number: locationList.count+1))
                        guard let locationData = try? JSONEncoder().encode(locationList) else{return}
                        customLocations = locationData
                    }
                    
                    locationAdded.toggle()
                }, label: {
                    Text("Submit Address").font(.title2)
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(Color(.gray))
                        .foregroundColor(.white)
                        .cornerRadius(20)//makes the button look nice
                    
                }).frame(width: 300, height: 100, alignment: .top)
                Button(action: {
                    locationList.append(customLocation(address: URlForm("618 Schiller ave", city: "Merion Station", state: "PA", zip: "19066"), oneLineAddress: "\("618 Schiller ave") \("Merion Station") \("PA") \("19066")", number: locationList.count+1))
                    
                    locationAdded.toggle()
                }, label: {
                    Text("Make it easy").font(.title2)
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(Color(.gray))
                        .foregroundColor(.white)
                        .cornerRadius(20)//makes the button look nice
                })
                Button(action: {
                    LocationManager.shared.requestLocation()
                    locationAdded.toggle()
                }, label: {
                    Text("Use Location Services").font(.title2)
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(Color(.gray))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                })
            }.padding()
            .background(Color(.systemBlue))
            .edgesIgnoringSafeArea(.all)
            }
            else if !redirectBack{
                ContentView()
            }
        }
    }
}


