//
//  backButton.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 3/29/22.
//
//  Gonna be honest, this file is completely uneccesary. 
//

import SwiftUI

struct backButton: View {
    var body: some View {
        ZStack{
            Rectangle().frame(width: 100, height: 30).opacity(0.6).cornerRadius(15)
        HStack{
            Image(systemName: "chevron.backward")
            Text("Back")
        }.foregroundColor(.red)
        }
    }
}


