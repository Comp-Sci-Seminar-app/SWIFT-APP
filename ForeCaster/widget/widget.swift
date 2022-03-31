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
        let test1 = f.responses.hour.time
        ZStack{
            let start = test1.index(test1.startIndex, offsetBy: 10)
            let end = test1.index(test1.endIndex, offsetBy: -3)
            let index = start..<end
            let test = (Int)(test1[index])
           if test! >= 19 || test! <= 7{
                Image("1069")
            }
           else{
                
                Image((String)(f.responses.condition.code))
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
            }
            VStack{
            Text((String)(f.responses.current.temp_f ) + " F")
                Text((String)(test!))
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
