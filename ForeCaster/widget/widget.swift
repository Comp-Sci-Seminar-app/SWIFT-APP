//
//  widget.swift
//  widget
//
//  Created by Lucas Laje (student LM) on 3/14/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
}


struct widgetEntryView : View {
    @StateObject var f = FetchData()
    @StateObject var g = Decoded()
    let test = 1
    var entry: Provider.Entry
    var body: some View {
        ZStack{
            if (timeToInt(f.responses.location.localtime) < 19 && timeToInt(f.responses.location.localtime) > 5){
                Image("\(f.responses.current.condition?.code ?? 1000)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                //if it is night, uses a different image
            }else{
                Image("night")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            VStack{
                Text((String)(f.responses.current.temp_f ) + " F")
                Text((String)(test))
            }
        }
    }
}

@main
struct widget: Widget {
    let kind: String = "widget"
    
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

//FAR from the best way to do it, but its how im gonna do it so fight me!
func timeToInt(_ rawTime : String) -> Int {
    let tTime0 : String = String(rawTime[rawTime.lastIndex(of: " ")!...])
    let tTime : String = String(tTime0.dropFirst())
    let tTime2 : String = String(tTime[...tTime.firstIndex(of: ":")!])
    let tTime3 : String = String(tTime2.dropLast())
    let time = Int(tTime3) ?? 0
    return time
}
