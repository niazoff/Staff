//
//  MainViewController.swift
//  BogusCode
//
//  Created by Natanel Niazoff on 11/6/17.
//  Copyright © 2017 Natanel Niazoff. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

class MainViewController: UITableViewController, NSURLConnectionDelegate {
    var objects: NSMutableArray = NSMutableArray()
    var pictures: NSMutableArray = NSMutableArray()
    var url: String = String()
    var kOneConstant = 1
    
    struct API {
        static let token = "4a5f06d19249c1cfd67b09055bf13e01"
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Vimeo Staff ❤️"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let url = URL(string: "https://api.vimeo.com/channels/staffpicks/videos")!
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 0)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("bearer \(API.token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                self.objects = NSMutableArray(array: (json["data"] as! [Any]))
                print(self.objects.count)
//                print((json["data"] as! [Any]).count)
//                let videos = try JSONDecoder().decode(RawVideo.self, from: data!)
//                print(videos.data)
            }
            catch let jsonError {
                print(jsonError)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return kOneConstant
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView = tableView
        return 1000
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: self.view.bounds)
        
        if self.objects.count > 0
        {
            let object = self.objects.object(at: indexPath.row)
            
            var name: String = "unknown"
            if let objectDictionary = object as? Dictionary<String, AnyObject>
            {
                name = (objectDictionary["name"] as? String)!
            }
            cell.textLabel!.text = name
            
            if let objectDictionary = object as? Dictionary<String, AnyObject>
            {
                if let pictures = objectDictionary["pictures"]
                {
                    if let picturesDictionary = pictures as? Dictionary<String, AnyObject>
                    {
                        if let sizes = picturesDictionary["sizes"]
                        {
                            if let sizesArray = sizes as? Array<AnyObject>
                            {
                                let first = sizesArray[0]
                                let firstDictionary = first as! Dictionary<String, AnyObject>
                                let link = firstDictionary["link"] as! String
                                url = link
                            }
                        }
                    }
                }
            }
            
            var image: UIImage?
            do
            {
            image = UIImage(data: try Data(contentsOf: URL(string: url)!))
            } catch {
                print("bad image")
                image = UIImage()
            }
            
            cell.imageView!.image = image
            
            if cell.textLabel?.text == ""
            {
                cell.textLabel!.text = "no more videos, scroll up…"
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
