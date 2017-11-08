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
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.title = "Vimeo Staff ❤️"
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MainViewController.loadVideos), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        loadVideos()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredVideos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = filteredVideos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! VideoTableViewCell
        cell.videoLabel.text = video.name
        cell.userLabel.text = video.user
        cell.viewsLabel.text = "\(video.views)"
        cell.likesLabel.text = "\(video.likes)"
        cell.videoImageView.setImage(with: video.url) { image in
            cell.layoutSubviews()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @objc func loadVideos() {
        APIHelper.loadVideos { videos in
            self.videos = videos
            self.filteredVideos = videos
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredVideos = videos.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            filteredVideos = videos
        }
        tableView.reloadData()
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
