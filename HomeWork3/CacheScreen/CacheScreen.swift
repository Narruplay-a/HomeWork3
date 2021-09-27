//
//  CacheScreen.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 16.09.2021.
//

import SwiftUI

struct CacheScreen: View {
    @ObservedObject
    var model: CacheScreenModel

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("Фотографии планет")
                    .font(.title)
                    .padding(.top, 20)
                
                ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
                    ForEach(model.earthData, id: \.identifier) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Дата фотографии:")
                                    .font(.system(size: 13).bold())
                                Text("Время фотографии:")
                                    .font(.system(size: 13).bold())
                                    .padding(.top, 5)
                            }

                            VStack(alignment: .leading) {
                                Text(item.date)
                                    .font(.system(size: 15))
                                Text(item.time)
                                    .font(.system(size: 15))
                                    .padding(.top, 3)
                            }

                            Spacer()
                        }
                    }
                }
                .padding(.top, 20)
            }
            .padding(.all, 20)
        }
        .frame(width: UIScreen.main.bounds.width)
        .onAppear {
            model.loadData()
        }
    }
}
