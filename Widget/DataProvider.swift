//
//  DataProvider.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 20.08.2021.
//

import Foundation
import SwiftUI

final class DataProvider {
    static func loadData(_ callback: @escaping ([SuffixItem]) -> Void) {
        guard #available(iOS 14.0, *), let groupUserDefaults = UserDefaults(suiteName: "group.otus.homework3") else { return }

        if let dict = groupUserDefaults.value(forKey: "share_dict") as? [String: Int] {
            var items: [SuffixItem] = []
            for item in dict {
                if item.key.count <= 3 {
                    items.append(SuffixItem(suffix: item.key, count: item.value))
                }
            }
            
            items.sort { one, two in
                return one.suffix.lowercased() < two.suffix.lowercased()
            }
            
            callback(items)
        } else {
            callback([])
        }
    }
}


