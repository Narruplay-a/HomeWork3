//
//  CTextView.swift
//  Osago
//
//  Created by Adel Khaziakhmetov on 28.07.2021.
//

import SwiftUI
import Combine

struct CTextView: View {
    @State
    var state                       : TextFieldState                = .empty
    @State
    var isFirstResponder            : Bool                          = false

    var text                        : Binding<String>
    var tag                         : Int

    init(tag: Int, text: Binding<String>) {
        self.tag                    = tag
        self.text                   = text
    }
    
    var body: some View {
        VStack {
            ZStack {
                if text.wrappedValue.count > 0 {
                    Text("").hidden()
                }
                VStack {
                    HStack {
                        Text("Текст")
                            .padding(.top, 4)
                            .padding([.leading, .trailing], 12)
                            .font(.system(size: 11))
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    
                    textField
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .padding([.leading, .trailing], 12)
                        .padding(.top, isInValueState() ? -5 : 20)
                        .padding(.bottom, 20)
                }
            }
            .background(Color.white)
            .border(Color.gray, width: 1)
        }
    }
}

extension CTextView {
    var textField: RepresentableTextView {
        RepresentableTextView(tag: tag,
                              text: text,
                              isFirstResponder: $isFirstResponder,
           onEditingStart: { text in
            if text.count == 0 || state == .error || state == .value || state == .empty {
                state = .editing
            }
        }, onEditingEnd: { text in
            if text.count == 0, (state == .value || state == .editing) {
                state = .empty
            } else if text.count > 0 {
                state = .value
            }
            
            isFirstResponder = false
        })
    }
    
    func isInValueState() -> Bool {
        return state == .value || state == .editing || (state == .error && text.wrappedValue.count > 0) || text.wrappedValue.count > 0
    }
}

enum TextFieldState {
    case empty
    case value
    case editing
    case error
}
