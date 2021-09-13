//
//  Profiler.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 06.09.2021.
//

import Foundation

final class Profiler {
    class func run(callback: () -> Void) -> TimeInterval {
        let start = CFAbsoluteTimeGetCurrent()
        callback()
        let end = CFAbsoluteTimeGetCurrent()

        return end - start
    }
}
