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
            
            List(model.historyData, id: \.title) { item in
                HistoryCell(data: item, color: color(for: item))
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
    
    func color(for item: HistoryData) -> Color {
        guard item.index != -1 else { return .white }
        
        if model.minimalIndex == item.index {
            return .green
        }

        if model.maximumIndex == item.index {
            return .red
        }
        
        return .white
    }
}
