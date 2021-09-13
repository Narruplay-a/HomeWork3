//
//  SuffixScreen.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 20.08.2021.
//

import SwiftUI

struct SuffixScreen: View {
    @ObservedObject
    var model: SuffixScreenModel
    
    var body: some View {
        VStack {
            CustomPicker(selection: $model.pickerSelection,
                         items: ["Все суффиксы", "Популярные"])
                .padding(.all, 20)
            
            switch model.pickerSelection {
            case 0:
                allSuffixView
            default:
                popularSuffixView
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .onAppear {
            model.updateModel()
        }
    }
    
    var allSuffixView: some View {
        VStack {
            Toggle(isOn: $model.isAscending, label: {
                Text("Сортировка по возрастанию")
            })
            .padding([.leading, .trailing, .bottom], 20)
            
            TextField("Поиск", text: $model.searchString)
                .padding([.leading, .trailing, .bottom], 20)
            
            ScrollView {
                ForEach(model.sortedSuffixItems, id: \.suffix) { item in
                    VStack {
                        HStack {
                            Text(item.suffix)
                            Spacer()
                            Text(item.count.description)
                        }
                        .frame(height: 24)
                        .padding([.leading, .trailing], 20)
                        Divider()
                    }
                }
            }
        }
    }
    
    var popularSuffixView: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    ForEach(model.popularRange) { index in
                        VStack {
                            HStack {
                                Text(model.threeLetterSuffixItems[index].suffix)
                                Spacer()
                                Text(model.threeLetterSuffixItems[index].count.description)
                            }
                            .frame(height: 24)
                            .padding([.leading, .trailing], 20)
                            Divider()
                        }
                    }
                }
            }
            .frame(minHeight: geometry.size.height)
        }
    }
}
