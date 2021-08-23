//
//  WdgetService.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 19.08.2021.
//

import WidgetKit

final class WidgetService {
    static func updateWidgetData(with suffixDict: [SuffixItem]) {
        guard #available(iOS 14.0, *), let groupUserDefaults = UserDefaults(suiteName: "group.otus.homework3") else { return }

        var dict: [String: Int] = [:]
        
        for item in suffixDict {
            dict.updateValue(item.count, forKey: item.suffix)
        }
        
        groupUserDefaults.setValue(dict, forKey: "share_dict")
        #if arch(arm64) || arch(i386) || arch(x86_64)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
}
