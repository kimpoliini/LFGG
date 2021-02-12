//
//  Game.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-11.
//

import Foundation

struct Game {
    var id = UUID()
    var title: String
    var platforms: [String]
    var genres = [String]()
    var headerImageUrl: String? = nil
    var iconImageUrl: String? = nil    
}
