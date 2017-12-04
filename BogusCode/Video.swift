//
//  Video.swift
//  BogusCode
//
//  Created by Natanel Niazoff on 11/7/17.
//  Copyright © 2017 Natanel Niazoff. All rights reserved.
//

import Foundation

class Video: Decodable, CustomStringConvertible {
    let name: String
    var user = ""
    let url: URL
    var views = 0
    var likes = 0
    var isMature = false

    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }

    convenience init(from data: RawVideos.Data) {
        self.init(name: data.name, url: data.pictures.sizes.first!.link)
        user = data.user.name
        views = data.stats.plays ?? 0
        likes = data.metadata.connections.likes.total
        if data.contentRating[0] != "safe" {
            isMature = true
        }
    }
    
    var description: String {
        return name
    }
}

struct RawVideos: Decodable {
    let data: [Data]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    struct Data: Decodable {
        let name: String
        let user: User
        let pictures: Pictures
        let metadata: Metadata
        let stats: Stats
        let contentRating: [String]
        
        enum CodingKeys: String, CodingKey {
            case name, user, pictures, metadata, stats
            case contentRating = "content_rating"
        }
        
        struct User: Decodable {
            let name: String
            
            enum CodingKeys: String, CodingKey {
                case name
            }
        }
        
        struct Pictures: Decodable {
            let sizes: [Size]
            
            enum CodingKeys: String, CodingKey {
                case sizes
            }
            
            struct Size: Decodable {
                let link: URL
                
                enum CodingKeys: String, CodingKey {
                    case link
                }
            }
        }
        
        struct Metadata: Decodable {
            let connections: Connections
            
            enum CodingKeys: String, CodingKey {
                case connections
            }
            
            struct Connections: Decodable {
                let likes: Likes
                
                enum CodingKeys: String, CodingKey {
                    case likes
                }
                
                struct Likes: Decodable {
                    let total: Int
                    
                    enum CodingKeys: String, CodingKey {
                        case total
                    }
                }
            }
        }
        
        struct Stats: Decodable {
            let plays: Int?
        }
    }
}
