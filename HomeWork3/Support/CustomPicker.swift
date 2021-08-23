//
//  CustomPicker.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 20.08.2021.
//

import SwiftUI

struct CustomPicker: View {
    @Binding
    var selection: Int
    @State
    var items: [String] = []
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                ForEach(items.indices) { index in
                    VStack {
                        Text(items[index])
                            .font(.system(size: 18))
                            .foregroundColor(selection == index ? Color.white : Color.black)
                    }
                    .frame(width: geometry.size.width / CGFloat(items.count), height: geometry.size.height)
                    .background(selection == index ? Color.gray : Color.white)
                    .onTapGesture {
                        self.selectView(with: index)
                    }
                }
            }
            .frame(height: 38)
            .background(Color.white)
            .cornerRadius(8)
            .clipped()
        }
        .frame(height: 38)
    }
    
    private func selectView(with index: Int) {
        withAnimation(Animation.easeInOut.speed(2)) {
            selection = index
        }
    }
}
