//
//  AppDetailViewController.swift
//  AppStore
//
//  Created by Jongwon Woo on 25/06/2017.
//  Copyright © 2017 WooJongwon. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AppDetailViewController: UIViewController {

    var appInfo: AppInfo?
    let queryService = AppQueryService()
    var appDetailInfo: AppDetailInfo?
    
    
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var userRatingLabel: UILabel!
    
    @IBOutlet weak var screenshotsCollectionView: UICollectionView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var releaseNotesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showAppInfo()
        
        guard let appInfo = self.appInfo else { return }
        
        queryService.getSearchResults(appId: appInfo.identifier) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let result = result {
                self.appDetailInfo = result
                self.showAppDetailInfo()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func showAppInfo() {
        guard let appInfo = self.appInfo else { return }
        
        iconView.layer.borderColor = UIColor.lightGray.cgColor
        iconView.loadImage(url: appInfo.iconUrl)
        appNameLabel.text = appInfo.name
        sellerNameLabel.text = appInfo.sellerName
    }
    
    private func showAppDetailInfo() {
        guard let detailInfo = self.appDetailInfo else { return }
        
        let max = 5
        let rating = Int(detailInfo.userRating)
        userRatingLabel.text = String(repeating: "★", count: rating) + String(repeating: "☆", count: max - rating)
        descriptionLabel.text = detailInfo.description
        releaseNotesLabel.text = detailInfo.releaseNotes
        screenshotsCollectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension AppDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        
        if let detailInfo = self.appDetailInfo {
            count = detailInfo.screenshotUrls.count
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ScreenshotCell
        
        if let detailInfo = self.appDetailInfo {
            let urls = detailInfo.screenshotUrls
            let urlString = urls[indexPath.item]
            if let url = URL(string: urlString) {
                cell.screenshotImageView.loadImage(url: url)
            }
        }
        
        return cell
    }
}
