//
//  TaskService.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 06.09.2021.
//

import Foundation
import Combine

typealias Subject = PassthroughSubject

final class JobScheduler<T: Job> {
    let completeSubject         : Subject<[T], Never>   = Subject()
    let executingQueue          : DispatchQueue         = DispatchQueue(label: "task.queue")
    let jobQueue                : JobQueue              = JobQueue()
    
    private var isExecuting     : Bool                  = false
    private var completedJobs   : [T]                   = []
    
    func add(task: T) {
        jobQueue.add(task: task)
    }
    
    func start() {
        isExecuting = true
        execute()
    }
    
    private func execute() {
        guard let task = jobQueue.getTask() else {
            complete()
            return
        }
        
        task.execute(on: executingQueue) { [weak self] job in
            guard let self = self else { return }
            
            self.jobQueue.remove()
            self.completedJobs.append(job as! T)
            self.execute()
        }
    }
    
    private func complete() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isExecuting = false
            self.completeSubject.send(self.completedJobs)
            self.completedJobs = []
        }
    }
}
