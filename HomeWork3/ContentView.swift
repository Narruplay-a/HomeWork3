//
//  ContentView.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 19.08.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject
    var model   : ContentViewModel  = ContentViewModel()
    var service : CoreDataService   = CoreDataService()
    
    var body: some View {
        TabView(selection: $model.tabSelection) {
            TextInputScreen(model: model.textInputScrennModel)
                .tag(0)
                .tabItem {
                    Text("Ввод")
                }
            SuffixScreen(model: model.suffixScreenModel)
                .tag(1)
                .tabItem{
                    Text("Суффикс")
                }
            
            HistoryScreen(model: model.historyScreenModel)
                .tag(2)
                .tabItem{
                    Text("История")
                }
            
            CacheScreen(model: model.cacheScreenModel)
                .tag(3)
                .tabItem{
                    Text("Кэш")
                }
        }
        .onAppear {
            model.selectScreen()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            model.selectScreen()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            service.saveContext()
        }
        .onOpenURL(perform: { url in
            if url.absoluteString == "test_url" {
                model.tabSelection = 0
            } else {
                model.tabSelection = 1
            }
        })
    }
}

final class ContentViewModel: ObservableObject {
    let textInputScrennModel: TextInputScreenModel  = .init()
    let suffixScreenModel   : SuffixScreenModel     = .init()
    let historyScreenModel  : HistoryScreenModel    = .init()
    let cacheScreenModel    : CacheScreenModel      = .init()
    
    @Published
    var tabSelection: Int = 0
    
    func selectScreen() { }
}
