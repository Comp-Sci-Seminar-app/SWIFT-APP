//
//  DIssapearingView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 3/8/22.
//

import SwiftUI

struct DIssapearingView: View {
    var data : Current
    var body: some View {
        
        HStack{
            Text("The Forcast for today is \(data.condition?.text ?? "still loading")").font(.system(size: 17))    .foregroundColor(.black)
            Spacer()
            Image("wireframe").resizable().frame(width: 60, height: 60)
        }.background(Color.white.opacity(1)).cornerRadius(20)
    }
}
