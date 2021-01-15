//
//  Stock.swift
//  technology-stack
//
//  Created by Niles Bingham on 1/14/21.
//

import Foundation

struct Item {
    var id: UUID
    var name: String
    var price: Float
    var images: [Img]
}

struct Img {
    var name: String
    var url: String
    var size: [Int]
}

class ItemManager {
    
}
