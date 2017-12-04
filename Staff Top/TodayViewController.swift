//
//  TodayViewController.swift
//  Staff Top
//
//  Created by Natanel Niazoff on 12/3/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    var video: Video?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var viewsImageView: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var likesImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var matureImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        
        imageView.layer.cornerRadius = 3
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        update()
        completionHandler(NCUpdateResult.newData)
    }
    
    func update() {
        activityIndicator.startAnimating()
        APIHelper.loadVideos() { videos, error in
            self.video = videos.first
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.setup()
            }
        }
    }
    
    func setup() {
        if let video = video {
            [imageView, videoLabel, userLabel].forEach() { $0.isHidden = false }
            
            videoLabel.text = video.name
            userLabel.text = video.user
            matureImageView.isHidden = !video.isMature
            imageView.setImage(with: video.url)
            
            // If video has views...
            if video.views > 0 {
                // ...unhide needed views and set to appropriate data.
                viewsLabel.isHidden = false
                viewsImageView.isHidden = false
                viewsLabel.text = video.views.decimalFormattedString
            } else {
                viewsLabel.isHidden = true
                viewsImageView.isHidden = true
            }
            // If video has likes...
            if video.likes > 0 {
                // ...unhide needed views and set to appropriate data.
                likesLabel.isHidden = false
                likesImageView.isHidden = false
                likesLabel.text = video.likes.decimalFormattedString
            } else {
                likesLabel.isHidden = true
                likesImageView.isHidden = true
            }
        }
    }
}
