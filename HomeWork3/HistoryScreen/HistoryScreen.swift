//
//  HistoryScreen.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 06.09.2021.
//

import SwiftUI

struct HistoryScreen: View {
    @ObservedObject
    var model: HistoryScreenModel

    var body: some View {
        VStack(spacing: 0) {
            Button("Провести тест") {
                model.runTest()
            }
            .padding(.all, 20)
            
            ScrollView {
                ForEach(model.historyData, id: \.title) { item in
                    HistoryCell(data: item)
                }
            }
            
            Button("Создать историю...") {
                model.createOrAppendHistoryData()
            }
            .padding(.all, 20)
        }
        .frame(width: UIScreen.main.bounds.width)
        .onAppear {
            model.loadHistoryData()
        }
    }
    
    func color(for index: Int) -> Color {
        guard model.minimalIndex != model.maxIndex else { return .white }
        
        if index == model.minimalIndex {
            return .green
        } else if index == model.maxIndex {
            return .red
        }
        
        return .white
    }
}
