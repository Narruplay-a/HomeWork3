//
//  Task.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 06.09.2021.
//

import Foundation

protocol Job {
    var actionCallback  : () -> Void        { get set }
    
    func execute(on queue: DispatchQueue?,
                 with callback: @escaping (Job) -> Void)
}

final class MeasureJob: Job {
    var measureTime     : TimeInterval?
    var actionCallback  : () -> Void
    
    init(_ callback: @escaping () -> Void) {
        actionCallback = callback
    }
    
    func execute(on queue: DispatchQueue?, with callback: @escaping (Job) -> Void) {
        let queue = queue ?? DispatchQueue.global()
        queue.async {
            self.measureTime = Profiler.run {
                self.actionCallback()
            }
            callback(self)
        }
    }
}
