//
//  CacheService.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 14.09.2021.
//

import Foundation

protocol CacheProtocol {
    func cacheToUserDefault(data: [HistoryData])
    func cacheToFile(data: [HistoryData])
    func loadDataFromFile() -> [HistoryData]
}

final class CacheService: CacheProtocol {
    private let path = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0].appendingPathComponent("cache")
    private let coreDataService: CoreDataService = .init()
    
    func cacheToUserDefault(data: [HistoryData]) {
        guard let jsonData: Data = try? JSONEncoder().encode(data) else { return }
        
        UserDefaults.standard.set(jsonData, forKey: "cached_history_data")
    }
    
    func cacheToCoreData(data: [EarthModel]) {
        coreDataService.clearRepository()
        
        for model in data {
            let earthEntity = coreDataService.createObject(for: "EarthEntity") as! EarthEntity
            earthEntity.identifier = model.identifier
            earthEntity.caption = model.caption
        }
        
        coreDataService.saveContext()
    }
    
    func cacheToFile(data: [HistoryData]) {
        guard let jsonData: Data = try? JSONEncoder().encode(data) else { return }
        
        try? jsonData.write(to: path)
    }
    
    func loadDataFromFile() -> [HistoryData] {
        guard let jsonData = try? Data(contentsOf: path),
              let data = try? JSONDecoder().decode(Array<HistoryData>.self, from: jsonData) else { return [] }
        
        return data
    }
    
    func loadDataFromUserDefaults() -> [HistoryData] {
        guard let jsonData = UserDefaults.standard.data(forKey: "cached_history_data"),
              let data = try? JSONDecoder().decode(Array<HistoryData>.self, from: jsonData) else { return [] }
        
        return data
    }
    
    func loadFromCacheData() -> [EarthModel] {
        let entities = coreDataService.getObjects(for: "EarthEntity") as! [EarthEntity]
        
        var data: [EarthModel] = []
        for entity in entities {
            let item = EarthModel(identifier: entity.identifier, caption: entity.caption)
            data.append(item)
        }
        
        return data
    }
}
