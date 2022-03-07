//
//  LocationRequestView.swift
//  ForeCaster
//
//  Created by Samuel Conry-Murray (student LM) on 3/7/22.
//

import SwiftUI

struct LocationRequestView: View {
    var body: some View {
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
                    }, label: {
                        Text("Allow Access").frame(width:120)
                    }).padding()
                    .background(Color.blue)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    Button(action: {
                        print("L")
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
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
