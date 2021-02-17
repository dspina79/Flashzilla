//
//  Card.swift
//  Flashzilla
//
//  Created by Dave Spina on 2/13/21.
//

import Foundation


struct Card: Codable, Identifiable, Hashable {
    let id = UUID()
    let prompt: String
    var answer: String
    
    static var example: Card {
        Card(prompt: "Who played the 11th Doctor in 'Doctor Who'", answer: "Matt Smith")
    }
}
