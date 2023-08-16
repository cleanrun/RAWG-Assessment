//
//  CoreDataManager.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 15/08/23.
//

import Foundation
import CoreData

struct CoreDataManagerDependencyKey: DependencyKey {
    static var currentValue: CoreDataManager = CoreDataManager()
}

final class CoreDataManager {
    private let stack: CoreDataStack
    let managedContext: NSManagedObjectContext
    
    init() {
        stack = CoreDataStack()
        managedContext = stack.managedContext
    }
    
    func getAllGames() -> [Game] {
        let fetchRequest: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        var requestResult = [Game]()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if !results.isEmpty {
                requestResult = results.map {
                    Game(from: $0)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return requestResult
    }
    
    func saveGame(_ game: Game) {
        let entity = game.asEntity(with: managedContext)
        stack.saveContext()
    }
    
    func findGame(byId gameID: Int) -> GameEntity? {
        let fetchRequest: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gameID == %d", Int32(gameID))
        
        var result: GameEntity? = nil
        
        do {
            result = try managedContext.fetch(fetchRequest).first
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    func deleteGame(_ id: Int) {
        if let entity = findGame(byId: id) {
            managedContext.delete(entity)
            stack.saveContext()
        }
    }
    
}
