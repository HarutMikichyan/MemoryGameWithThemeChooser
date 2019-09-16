//
//  Card.swift
//  MemoryGame
//
//  Created by 1 on 9/11/19.
//  Copyright © 2019 1. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    init() {
        self.identifier = Card.generatiomUniqueIdentifier()
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    //MARK: - Generation Identifier
    static var uniqueIdentifier: Int = 0
    static func generatiomUniqueIdentifier() -> Int {
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
}
