//
//  HistoryCell.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 06.09.2021.
//

import SwiftUI

struct HistoryCell: View {
    let data    : HistoryData
    let color   : Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Текст:")
                    .bold()
                    .foregroundColor(.gray)
                Text(formattedTitle())
                Spacer()
            }
            .padding(.leading, 15)
            
            HStack {
                Text("Количество символов:")
                    .bold()
                    .foregroundColor(.gray)
                Text(String(format: "%ld", data.title.count))
                Spacer()
            }
            .padding(.leading, 15)
            
            if let time = data.time {
                HStack {
                    Text("Время теста:")
                        .bold()
                        .foregroundColor(.gray)
                    Text(time == 0 ? "Тест не проводился" : String(describing: time))
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.leading, 15)
            }
        }
        .background(color)
    }
    
    private func formattedTitle() -> String {
        guard data.title.count > 20 else { return data.title }
        
        let str = data.title
        return String(str[str.startIndex..<str.index(str.startIndex, offsetBy: 19)]) + "..."
    }
}

struct HistoryData {
    let title   : String
    
    var index   : Int            = -1
    var time    : TimeInterval   = 0
}
