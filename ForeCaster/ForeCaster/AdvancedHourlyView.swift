//
//  AdvancedHourlyView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 2/24/22.
//

import SwiftUI

struct AdvancedHourlyView: View {
    @Binding var data : HPeriods
    
    var body: some View {
        ZStack{
            VStack{
                Text("sadness")
            }.frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - 20)
            .background(Color.gray)
            
        }.background(Color.blue)
    }
}

