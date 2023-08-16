//
//  GameEntity+CoreDataProperties.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 16/08/23.
//
//

import Foundation
import CoreData

extension GameEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameEntity> {
        return NSFetchRequest<GameEntity>(entityName: "GameEntity")
    }

    @NSManaged public var gameID: Int32
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var released: String?
    @NSManaged public var backgroundImage: String?
    
    func asModel() -> Game {
        return Game(from: self)
    }

}

extension GameEntity : Identifiable {}
