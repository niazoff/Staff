//
//  Video.swift
//  BogusCode
//
//  Created by Natanel Niazoff on 11/7/17.
//  Copyright © 2017 Natanel Niazoff. All rights reserved.
//

import Foundation

class Video: Decodable {
    let name: String
    let link: String
    
    init(name: String, link: String) {
        self.name = name
        self.link = link
    }
    
    required init(for decoder: Decoder) throws {
        let rawVideo = try RawVideo(from: decoder)
        name = rawVideo.data.name
        link = rawVideo.data.pictures.first!.sizes.first!.link
    }
}

private struct RawVideo: Decodable {
    let data: Data
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    struct Data: Decodable {
        let name: String
        let pictures: [Picture]
        
        enum CodingKeys: String, CodingKey {
            case name, pictures
        }
    }
    
    struct Picture: Decodable {
        let sizes: [Size]
        
        enum CodingKeys: String, CodingKey {
            case sizes
        }
    }
    
    struct Size: Decodable {
        let link: String
        
        enum CodingKeys: String, CodingKey {
            case link
        }
    }
}
