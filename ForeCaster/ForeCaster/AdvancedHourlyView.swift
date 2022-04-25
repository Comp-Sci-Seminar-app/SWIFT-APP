//
//  AdvancedHourlyView.swift
//  ForeCaster
//
//  Created by Ari Steinfeld (student LM) on 2/24/22.
//

import SwiftUI
import struct Kingfisher.KFImage

struct AdvancedHourlyView: View {
    var data : HPeriods
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        ZStack{
            Rectangle().frame(width: 80, height: 30).foregroundColor(Color.white.opacity(0.7)).cornerRadius(15)
        HStack{
            Image(systemName: "chevron.backward")
            Text("Back")
        }.foregroundColor(.red)
        }
    }
    }
    var body: some View {
        
        
        ZStack{
            ZStack{
                VStack{
                    Spacer()
                    HStack{
                        Text("Forcast for \(makeTimeNice(data.startTime))")
                        KFImage(URL(string: data.icon)).resizable().frame(width: 50, height: 50).clipShape(Circle())
                    }.frame(width: UIScreen.main.bounds.width - 80, height: 50).background(Color.customGray.opacity(0.6)).cornerRadius(10)
                    Spacer()
                    VStack{
                        Spacer()
                        
                        HStack{
                            Text("Short Forcast: \(data.shortForecast ?? "no data bro")")
                        }.frame(width: UIScreen.main.bounds.width - 80, height: 95).background(Color.customGray.opacity(0.6)).cornerRadius(15)
                        Spacer()
                        HStack{
                            Spacer()
                            Spacer()
                            VStack{
                                Spacer()
                                Text("Wind speed:")
                                Text("\(data.windSpeed)")
                                Spacer()
                            }.frame(width: UIScreen.main.bounds.width - 180, height: 95).background(Color.customGray.opacity(0.6)).cornerRadius(15)
                            Spacer()
                            VStack{
                                Spacer()
                                Text("Wind direction: ")
                                Text("\(data.windDirection)")
                                Spacer()
                            }.frame(width: UIScreen.main.bounds.width - 180, height: 95).background(Color.customGray.opacity(0.6)).cornerRadius(15)
                            Spacer()
                            Spacer()
                        }.frame(width: UIScreen.main.bounds.width - 80, height: 95)
                        Spacer()
                        HStack{
                            Spacer()
                            Spacer()
                            VStack{
                                Spacer()
                                Text("Temperature:")
                                Text("\(data.temperature) degrees f")
                                Spacer()
                            }.frame(width: UIScreen.main.bounds.width - 180, height: 95).background(Color.customGray.opacity(0.6)).cornerRadius(15)
                            Spacer()
                            VStack{
                                Spacer()
                                Text("Daytime:")
                                Group{
                                    if data.isDaytime{
                                        Text("Day")
                                    }
                                    else{
                                        Text("Night")
                                    }
                                }
                                Spacer()
                            }.frame(width: UIScreen.main.bounds.width - 180, height: 95).background(Color.customGray.opacity(0.6)).cornerRadius(15)
                            Spacer()
                            Spacer()
                        }.frame(width: UIScreen.main.bounds.width - 80, height: 95)
                        Spacer()
                        Spacer()
                    }.frame(width: UIScreen.main.bounds.width - 80, height: 300)
                    Spacer()
                    Spacer()
                    Spacer()
                }.frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.height - 60)
             
            }
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).ignoresSafeArea(.all)
        .background(Image("background")
                        
                        .ignoresSafeArea(.all)
        )
        .navigationBarItems(leading: btnBack)
        .navigationBarBackButtonHidden(true)
        
        
    }
}

