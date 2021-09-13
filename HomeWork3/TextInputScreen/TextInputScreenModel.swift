//
//  TextInputScreenModel.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 20.08.2021.
//

import SwiftUI

final class TextInputScreenModel: ObservableObject {
    @Published
    var inputText: String = ""
    
    func loadText() {
        inputText = UserDefaults.standard.string(forKey: "shared_text") ?? ""
    }
    
    func saveText() {
        UserDefaults.standard.setValue(inputText, forKey: "shared_text")
        if var historyArray = UserDefaults.standard.stringArray(forKey: "history_data") {
            historyArray.append(inputText)
            UserDefaults.standard.set(historyArray, forKey: "history_data")
        } else {
            var historyArray: [String] = .init()
            historyArray.append(inputText)
            UserDefaults.standard.set(historyArray, forKey: "history_data")
        }
    }
    
    func clearText() {
        inputText = ""
    }
}
