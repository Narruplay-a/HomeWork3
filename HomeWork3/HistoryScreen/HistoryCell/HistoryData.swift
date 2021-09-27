//
//  HistoryData.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 14.09.2021.
//

import Foundation

struct HistoryData: Codable {
    let title   : String
    
    var index   : Int            = -1
    var time    : TimeInterval   = 0
}
