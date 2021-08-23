//
//  TextInputScreen.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 20.08.2021.
//

import SwiftUI

struct TextInputScreen: View {
    @ObservedObject
    var model: TextInputScreenModel
    
    var body: some View {
        VStack {
            CTextView(tag: 0, text: $model.inputText)
                .padding(.all, 20)
            
            Button("Обработать текст") {
                model.saveText()
            }
            .padding(.all, 20)
            
            Button("Очистить") {
                model.clearText()
            }
            .padding(.all, 20)
        }
        .onAppear {
            model.loadText()
        }
    }
}
