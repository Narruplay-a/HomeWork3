//
//  DateExtension.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 14.09.2021.
//

import Foundation

extension Date {
    init?(from string: String, with format: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
}

extension String {
    init(from date: Date?, with format: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU_POSIX")
        dateFormatter.dateFormat = format
        
        if let date = date {
            self = dateFormatter.string(from: date)
        } else {
            self = ""
        }
    }
}
