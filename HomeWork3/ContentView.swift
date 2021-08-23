//
//  ContentView.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 19.08.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject
    var model: ContentViewModel = ContentViewModel()
    
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
        }
        .onAppear {
            model.selectScreen()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            model.selectScreen()
        }.onOpenURL(perform: { url in
            if url.absoluteString == "test_url" {
                model.tabSelection = 0
            } else {
                model.tabSelection = 1
            }
        })
    }
}

final class ContentViewModel: ObservableObject {
    let textInputScrennModel = TextInputScreenModel()
    let suffixScreenModel = SuffixScreenModel()
    
    @Published
    var tabSelection: Int = 0
    
    func selectScreen() {
        
    }
}
