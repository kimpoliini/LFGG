//
//  Rawg.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-03-01.
//

import Foundation

struct Rawg {
    let baseUrl = "https://api.rawg.io/api/games"
    
    func requestGames(query: String, completion: @escaping (_ success: [RawgGame]?) -> Void){
        var listGames = [RawgGame]()
        var queryUrl = baseUrl
        
        if !query.isEmpty {
            queryUrl += "?search=\(query)&page=1&page_size=20"
        }
        
        print(queryUrl)
        
        
        if let url = URL(string: queryUrl) {
            if let json = try? Data(contentsOf: url) {
                                
                let decoder = JSONDecoder()
                
//                    do {
//                        var jsonTest = try? decoder.decode(RawgGames.self, from: json)
//                        print(jsonTest)
//                    } catch let DecodingError.dataCorrupted(context) {
//                        print("context: \(context)")
//                    } catch let DecodingError.keyNotFound(key, context) {
//                        print("Key '\(key)' not found:", context.debugDescription)
//                        print("codingPath:", context.codingPath)
//                    } catch let DecodingError.valueNotFound(value, context) {
//                        print("Value '\(value)' not found:", context.debugDescription)
//                        print("codingPath:", context.codingPath)
//                    } catch let DecodingError.typeMismatch(type, context)  {
//                        print("Type '\(type)' mismatch:", context.debugDescription)
//                        print("codingPath:", context.codingPath)
//                    } catch {
//                        print("error: ", error)
//                    }
                    
                if let jsonGames = try? decoder.decode(RawgGames.self, from: json) {
                    listGames = jsonGames.results
                    
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
