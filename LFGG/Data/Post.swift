//
//  Post.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-03-03.
//

import Foundation

struct Post: Hashable {
    var user: User
    var date: Date
    var game: String
    var visibility: String = "friends"
    var action: String
    var platform: String? = nil
    var text: String? = nil
}
