//
//  Rawg.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-03-01.
//

import Foundation

struct Rawg {
    let baseUrl = "https://api.rawg.io/api/games"
    
    func requestGames(completion: @escaping (_ success: [RawgGame]?) -> Void){
        var listGames = [RawgGame]()
        
        if let url = URL(string: baseUrl) {
            if let json = try? Data(contentsOf: url) {
                
                let decoder = JSONDecoder()
                
                if let jsonGames = try? decoder.decode(RawgGames.self, from: json) {
                    listGames = jsonGames.results
                    print(listGames)
                    
//                    for game in listGames {
//                        listGamesString.append(game.)
//                    }
                    
                    completion(listGames)
                } else {
                    print("no json decoding here")
                    completion(nil)
                }
            } else {
                print("i dont know??")
                completion(nil)
            }
        } else {
            print("incorrect url?")
            completion(nil)
        }
    }
    
}
