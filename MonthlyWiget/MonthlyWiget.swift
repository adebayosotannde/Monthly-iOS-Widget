//
//  MonthlyWiget.swift
//  MonthlyWiget
//
//  Created by Adebayo Sotannde on 9/20/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntry] = []

       //Generate s timeline consisting of seven entireis a day apart, starting fromm the current date
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let starrtOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DayEntry: TimelineEntry
{
    let date: Date
}

struct MonthlyWigetEntryView : View
{
    var entry: DayEntry
    var config: MonthConfig
    init(entry: DayEntry) {
        self.entry = entry
        self.config = MonthConfig.determineConfig(from: entry.date)
    }
    
  

    var body: some View
    {
      ZStack
        {
            ContainerRelativeShape()
                .fill(config.backgroundColor.gradient)
            
            
            VStack
            {
                
                HStack
                {
                    Text(config.emojiText).font(.title)
                    Text(entry.date.weekdayDisplayFormat)
                        .font(.title3)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(config.weekdayTextColor)
                    Spacer()
                }
                
                Text(entry.date.dayDisplayFormat)
                    .font(.system(size: 80, weight: .heavy))
                    .foregroundColor(config.dayTextColor)
            }.padding().lineSpacing(4)
            
        }
    }
}

@main
struct MonthlyWiget: Widget {
    let kind: String = "MonthlyWiget"

    var body: some WidgetConfiguration
    {
        StaticConfiguration(kind: kind, provider: Provider())
        { entry in
            MonthlyWigetEntryView(entry: entry)
        }
        .configurationDisplayName("My Style Widget")
        .description("This theme of the Widget changes based on month.")
        .supportedFamilies([.systemSmall])
    }
}

struct MonthlyWiget_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyWigetEntryView(entry: DayEntry(date: dateToDisplay(month: 9, day: 22)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
    
    static func dateToDisplay(month: Int, day: Int) -> Date{
        let component = DateComponents(calendar: Calendar.current, year: 2022, month: month, day: day)
        return Calendar.current.date(from: component)!
    }
}


extension Date
{
    var weekdayDisplayFormat: String{
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var dayDisplayFormat : String
    {
        self.formatted(.dateTime.day())
    }
}
