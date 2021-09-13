//
//  RepresentableTextView.swift
//  Osago
//
//  Created by Adel Khaziakhmetov on 28.07.2021.
//

import SwiftUI

struct RepresentableTextView: UIViewRepresentable {
    @Binding
    var text           : String
    
    var isFirstResponder        : Binding<Bool>?
    var tag                     : Int
    var onEditingStart          : ((String) -> Void)?
    var onEditingEnd            : ((String) -> Void)?
    var onSelectionChanged      : ((String) -> Void)?
    var placeholder             : String = ""
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text           : String
        
        var placeholder             : String
        var onEditingStart          : ((String) -> Void)?
        var onEditingEnd            : ((String) -> Void)?
        var onSelectionChanged      : ((String) -> Void)?

        init(placeholder: String,
             text: Binding<String>,
             onEditingStart: ((String) -> Void)?,
             onEditingEnd: ((String) -> Void)?,
             onSelectionChanged: ((String) -> Void)?) {
            self.placeholder = placeholder
            self._text = text
            self.onEditingStart = onEditingStart
            self.onEditingEnd = onEditingEnd
            self.onSelectionChanged = onSelectionChanged
            
            super.init()
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            
            return true
        }
    
        func textViewDidChangeSelection(_ textView: UITextView) {
            text = textView.text
            onSelectionChanged?(text)
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            onEditingStart?(textView.text)
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            text = textView.text
            onEditingEnd?(text)
        }
    }

    init(tag: Int,
         text: Binding<String>,
         isFirstResponder: Binding<Bool>?,
         onEditingStart: ((String) -> Void)? = nil,
         onEditingEnd: ((String) -> Void)? = nil,
         onSelectionChanged: ((String) -> Void)? = nil) {
        self.tag                    = tag
        self._text                  = text
        self.isFirstResponder       = isFirstResponder
        self.onEditingStart         = onEditingStart
        self.onEditingEnd           = onEditingEnd
        self.onSelectionChanged     = onSelectionChanged
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView        = UITextView(frame: .zero)
   
        textView.tag        = tag
        textView.delegate   = context.coordinator

        return textView
    }
    
    func makeCoordinator() -> RepresentableTextView.Coordinator {
        return Coordinator(placeholder: placeholder,
                           text: $text,
                           onEditingStart: onEditingStart,
                           onEditingEnd: onEditingEnd,
                           onSelectionChanged: onSelectionChanged)
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        guard let responder = isFirstResponder?.wrappedValue else { return }
        
        switch responder {
            case true:
                uiView.becomeFirstResponder()
            case false:
                break
        }
    }
}
