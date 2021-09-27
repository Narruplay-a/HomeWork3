//
//  EarthEntity.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 14.09.2021.
//

import CoreData

class EarthEntity: NSManagedObject {
    @NSManaged var identifier  : String!
    @NSManaged var caption     : String!
    
    func getEarthModel() -> EarthModel {
        return EarthModel(identifier: identifier, caption: caption)
    }
}

struct EarthModel: Codable, Identifiable, Hashable {
    var id          : String
        {
            return identifier
        }
    let identifier  : String
    let caption     : String
    
    var date        : String {
        let dateString = String(identifier.prefix(8))
        
        return String(from: Date(from: dateString, with: "yyyyMMdd"), with: "dd MMMM yyyy")
    }
    
    var time        : String {
        let dateString = String(identifier.suffix(6))
        
        return String(from: Date(from: dateString, with: "HHmmss"), with: "HH:mm:ss")
    }
}


