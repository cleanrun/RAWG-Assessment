//
//  Game.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import Foundation

struct Game: Decodable, Hashable {
    var representedID = UUID()
    let id: Int
    let slug: String
    let name: String
    let released: String?
    let tba: Bool
    let backgroundImage: String?
    let rating: Double
    let metacritic: Double?
    let playtime: Double
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
}
