//
//  ListResponse.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import Foundation

struct ListResponse<T: Decodable>: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [T]
}
