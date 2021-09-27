//
//  CacheScreenModel.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 16.09.2021.
//

import SwiftUI
import Combine

final class CacheScreenModel: ObservableObject {
    @Published
    var earthData           : [EarthModel]      = []
    @Published
    var isDataFetching      : Bool              = false
    
    var networkService      : NetworkService    = .init()
    var dataService         : CoreDataService   = .init()
    
    private var cancellable : AnyCancellable?
    
    func loadData() {
        let entities = dataService.getObjects(for: "EarthEntity") as! [EarthEntity]
        guard entities.count > 0 else {
            fetchData()
            return
        }
        
        earthData = entities.map { $0.getEarthModel() }
    }
    
    private func fetchData() {
        isDataFetching = true
        cancellable = networkService.fetchEarthPhotos().sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                self?.isDataFetching = false
                print("SUCCESS!")
            case .failure:
                self?.isDataFetching = false
                print("FAIL!")
            }
        }, receiveValue: { [weak self] data in
            self?.earthData = data
            self?.cacheData()
        })
    }
    
    private func cacheData() {
        dataService.clearRepository()
        for item in earthData {
            let earthEntity = dataService.createObject(for: "EarthEntity") as! EarthEntity
            earthEntity.caption     = item.caption
            earthEntity.identifier  = item.identifier
        }
        
        dataService.saveContext()
    }
}
