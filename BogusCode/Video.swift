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
    let link: URL

    init(name: String, link: URL) {
        self.name = name
        self.link = link
    }

    convenience init(from data: RawVideos.Data) {
        self.init(name: data.name, link: data.pictures.sizes.first!.link)
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
        let pictures: Pictures
        
        enum CodingKeys: String, CodingKey {
            case name, pictures
        }
    }
    
    struct Pictures: Decodable {
        let sizes: [Size]
        
        enum CodingKeys: String, CodingKey {
            case sizes
        }
    }
    
    struct Size: Decodable {
        let link: URL
        
        enum CodingKeys: String, CodingKey {
            case link
        }
    }
}
