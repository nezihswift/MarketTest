//
//  Consumable.swift
//  MarketTest
//
//  Created by Nezih on 9.04.2023.
//

import Foundation

struct Consumable : Decodable {
    let id : String
    let name : String
    let price : Double
    let currency : String
    let imageUrl : String?
    let stock : Int
    var count : Int?
    
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case price
        case currency
        case imageUrl
        case stock
        case count
    }
}
