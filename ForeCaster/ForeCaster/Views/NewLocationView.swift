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
    @State private var CVshowing = false
    @Binding var showSheet : Bool
    @AppStorage("customLocations")
    private var customLocations: Data = Data()
    
    @State var locationList = [customLocation("", nickname: "")]
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        VStack{
            Text("Enter Address").font(.title)
            Spacer().frame(height: 40)
            TextField("Address",
                      text: $oneLineAddress)//Reads in address
            TextField("ZIP Code",
                      text: $zipCode).keyboardType(.numberPad)//reads in zip code
            TextField("City",
                      text: $city).disableAutocorrection(true)//reads in city
            TextField("State",
                      text: $state).disableAutocorrection(true)//reads in state
            Text("Use state abriviation i.e. New York -> NY").font(.footnote)//for user
            TextField("Nickname (Optional)", text: $nickname)//reads in optional nickname
            Spacer()
            Button(action: {//Stores entered values in appstorage to be used in perpetuity accross the app
                if nickname != ""{//Checks if a nickname was entered for the location
                    locationList.append(customLocation(address: oneLineAddress, nickname: nickname))//adds the entered info to the list of locations
                    guard let locationData = try? JSONEncoder().encode(locationList) else{return}//encodes the list of locations as JSON
                    customLocations = locationData//sets the encoded list equal to the appstorage thing
                }
                else{//does the same as above but without the address
                    locationList.append(customLocation(address: oneLineAddress))
                    guard let locationData = try? JSONEncoder().encode(locationList) else{return}
                    customLocations = locationData
                }
                showSheet = false
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Submit Address").font(.title2)
                    .frame(width: 250, height: 50, alignment: .center)
                    .background(Color(.gray))
                    .foregroundColor(.white)
                    .cornerRadius(20)//makes the button look nice
                
            }).frame(width: 300, height: 100, alignment: .top)
           
        }.padding()
        .background(Color(.systemBlue))
        .edgesIgnoringSafeArea(.all)
    }
}
