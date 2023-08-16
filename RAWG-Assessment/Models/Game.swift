//
//  Game.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import Foundation
import CoreData

struct Game: Decodable, Hashable {
    var representedID = UUID()
    let id: Int
    let slug: String?
    let name: String
    let released: String?
    let tba: Bool?
    let backgroundImage: String?
    let rating: Double
    let metacritic: Double?
    let playtime: Double?
    let description: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
        case released
        case tba
        case backgroundImage = "background_image"
        case rating
        case metacritic
        case playtime
        case description
    }
    
    init(from entity: GameEntity) {
        self.id = Int(entity.gameID)
        self.slug = nil
        self.name = entity.name ?? "nil"
        self.released = entity.released
        self.tba = nil
        self.backgroundImage = entity.backgroundImage
        self.rating = entity.rating
        self.metacritic = nil
        self.playtime = nil
        self.description = nil
    }
}

extension Game {
    func asEntity(with context: NSManagedObjectContext) -> GameEntity {
        let entity = GameEntity(context: context)
        entity.setValue(id, forKey: #keyPath(GameEntity.gameID))
        entity.setValue(name, forKey: #keyPath(GameEntity.name))
        entity.setValue(released, forKey: #keyPath(GameEntity.released))
        entity.setValue(rating, forKey: #keyPath(GameEntity.rating))
        entity.setValue(backgroundImage, forKey: #keyPath(GameEntity.backgroundImage))
        return entity
    }
}
