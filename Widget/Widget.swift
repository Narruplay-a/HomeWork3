//
//  Widget.swift
//  Widget
//
//  Created by Adel Khaziakhmetov on 20.08.2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), suffixItems: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), suffixItems: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let nextDate = Calendar.current.date(byAdding: .hour, value: 2, to: currentDate)!
        
        DataProvider.loadData { items in
            let entries = [
                SimpleEntry(date: currentDate, suffixItems: items),
                SimpleEntry(date: nextDate, suffixItems: items)
            ]

            let timeline = Timeline(entries: entries, policy: .atEnd)
            print("data loaded from cache")
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let suffixItems: [SuffixItem]
}

struct WidgetEntryView : View {
    static let deeplinkURL = URL(string: "widget-deeplink://")!
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemMedium:
            view()
        default:
            Text("Some other WidgetFamily in the future.")
        }
    }
    
    func view() -> some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    ForEach(0..<count()) { index in
                        VStack {
                            HStack {
                                Text(entry.suffixItems[index].suffix)
                                Spacer()
                                Text(entry.suffixItems[index].count.description)
                            }
                            .frame(height: 24)
                            .padding([.leading, .trailing], 20)
                            Divider()
                        }
                    }
                }
                .frame(width: geometry.size.width / 2)
                
                VStack(alignment: .center, spacing: 10) {
                    VStack {
                        Link("Первый экран", destination: URL(string: "test_url")!)
                            .foregroundColor(.white)
                            .padding(.all, 6)
                    }
                    .background(Color.blue)
                    .cornerRadius(6)
                    VStack {
                        Link("Второй экран", destination:URL(string: "test_url_2")!)
                            .foregroundColor(.white)
                            .padding(.all, 6)
                    }
                    .background(Color.red)
                    .cornerRadius(6)
                }
                .frame(height: geometry.size.height)
            }
        }
    }
    
    func count() -> Int {
        return entry.suffixItems.count > 3 ? 3 : entry.suffixItems.count
    }
}

@main
struct Widget: SwiftUI.Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

