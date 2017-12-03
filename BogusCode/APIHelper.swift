//
//  APIHelper.swift
//  BogusCode
//
//  Created by Natanel Niazoff on 11/8/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import Foundation

struct APIHelper {
    struct APIKeys {
        static let staffPicks = "https://api.vimeo.com/channels/staffpicks/videos"
        static let token = "99dc9b227290387fe1b47b678c16d5ef"
    }
    
    static func loadVideos(completionHandler: @escaping ([Video], Error?) -> Void) {
        let url = URL(string: APIKeys.staffPicks)!
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 0)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("bearer \(APIKeys.token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            var videos = [Video]()
            // If no error...
            if error == nil {
                //let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                //print(json)
                // ...decode json data from url into `RawVideo` object
                let rawVideos = try! JSONDecoder().decode(RawVideos.self, from: data!)
                // For all data objects in `RawVideo`...
                for videoData in rawVideos.data {
                    // ...parse in `Video` object and append to `videos`.
                    videos.append(Video(from: videoData))
                }
            }
            completionHandler(videos, error)
        }.resume()
    }
}
