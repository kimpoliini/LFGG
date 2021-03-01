//
//  RawgGame.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-03-01.
//

import Foundation

struct RawgGame: Codable, Hashable {
    let id = UUID()
    var name: String
    var background_image: String
//    var platforms: [String]
//    var genres: [String]
//    var imageUrl: String? = nil
}
