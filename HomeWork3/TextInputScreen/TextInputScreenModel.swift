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
    }
    
    func clearText() {
        inputText = ""
    }
}
