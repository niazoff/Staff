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

class MainViewController: UITableViewController {
    var videos = [Video]()
    var filteredVideos = [Video]()
    var searching = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    struct API {
        static let staffPicks = "https://api.vimeo.com/channels/staffpicks/videos"
        static let token = "4a5f06d19249c1cfd67b09055bf13e01"
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Vimeo Staff ❤️"
        
        let url = URL(string: API.staffPicks)!
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 0)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("bearer \(API.token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let rawVideos = try! JSONDecoder().decode(RawVideos.self, from: data!)
            for videoData in rawVideos.data {
                self.videos.append(Video(from: videoData))
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? filteredVideos.count : videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = video.name
        cell.imageView?.setImage(with: video.link) { image in
            cell.layoutSubviews()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            searching = true
            filteredVideos = videos.filter { $0.name.contains(searchBar.text!) }
            tableView.reloadData()
        }
    }
}

extension UIImageView {
    func setImage(with url: URL, completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                self.image = image
                completion(image!)
            }
        }.resume()
    }
}
