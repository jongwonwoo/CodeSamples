//
//  AppListViewController.swift
//  AppStore
//
//  Created by Jongwon Woo on 25/06/2017.
//  Copyright © 2017 WooJongwon. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AppListViewController: UICollectionViewController {

    var searchResults: [AppInfo] = []
    let queryService = AppListQueryService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        queryService.getSearchResults { results in
            self.searchResults = results
            self.collectionView?.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let detailVC = segue.destination as? AppDetailViewController,
                let indexPath = self.collectionView?.indexPathsForSelectedItems?.last
                else { return }
            
            detailVC.appInfo = searchResults[indexPath.item]
        }
    }
 
}

// MARK: UICollectionViewDataSource
extension AppListViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AppCell
    
        let appInfo = searchResults[indexPath.item]
        cell.nameLabel.text = appInfo.name
        cell.sellerLabel.text = appInfo.sellerName
        cell.iconView.loadImage(url: appInfo.iconUrl)
    
        return cell
    }
}

extension AppListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat(95.0)
        return CGSize(width: collectionView.bounds.width, height: height)
    }}
