//
//  TaskQueue.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 06.09.2021.
//

import Foundation

final class JobQueue {
    private var jobArray    : [Job?]    = [Job?](repeating: nil, count: 100)
    private let lock        : NSLock    = NSLock()
    private var jobArraySize: Int       = 100
    private var jobCount    : Int       = 0
    
    var header              : Int       = 0
    var tail                : Int       = 0

    func add(task: Job) {
        lock.lock()

        jobArray.insert(task, at: tail)
        
        jobCount += 1
        tail += 1
        tail = tail % jobArraySize
        
        expandArrayIfNeeded()
        
        lock.unlock()
    }

    func expandArrayIfNeeded() {
        guard tail == header else { return }
        
        jobArraySize += 100
        let tempArray = jobArray
        jobArray.append(contentsOf: [Job?](repeating: nil, count: 100))
        
        for i in header..<tempArray.count {
            jobArray[i - header] = tempArray[i]
        }
        
        guard header > 0 else { return }
        for i in 0..<header {
            jobArray[i + header] = tempArray[i]
        }
        
        header = 0
        tail = tempArray.count
    }
    
    func remove() {
        lock.lock()
        
        jobCount -= 1
        header += 1
        header = header % jobArraySize
        
        lock.unlock()
    }
    
    func getTask() -> Job? {
        guard tail != header else { return nil }
        
        return jobArray[header]
    }
}
