//
//  LivePhotoViewController.swift
//  LivePhotoPlayground
//
//  Created by jongwon woo on 2016. 10. 28..
//  Copyright © 2016년 jongwonwoo. All rights reserved.
//

import UIKit
import PhotosUI

class LivePhotoViewController: UIViewController {
    fileprivate let reuseIdentifier = "PhotoCell"
    
    @IBOutlet weak var photosCollectionView: CustomCollectionView!
    
    var selectedIndexPath: IndexPath?
    var photos: PHFetchResult<PHAsset>?
    
    private let photoFetcher = PhotoFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        photosCollectionView.reloadDataWithCompletion {
            self.photosCollectionView.reloadDataCompletionBlock = nil
            
            guard let indexPath = self.selectedIndexPath else { return }
            self.photosCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func showTitle(date: Date?) {
        guard let dateBind = date else { return }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        self.title = formatter.string(from: dateBind)
    }
}

// MARK: - UICollectionViewDataSource
extension LivePhotoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0;
        
        if let photos = self.photos {
            count = photos.count
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function + " \(indexPath)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LivePhotoCollectionViewCell
        
        if let photos = self.photos {
            let asset = photos[indexPath.item]
            cell.asset = asset
        }
        
        cell.indexPath = indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(#function + " \(indexPath)")
        
        if let photos = self.photos {
            let asset = photos[indexPath.item]
            if let creationDate = asset.creationDate {
                self.showTitle(date: creationDate)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(#function + " \(indexPath)")
    }
}

// MARK: - UICollectionView delegate
extension LivePhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LivePhotoViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        print(#function + " \(indexPath)")
        
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //        print(#function)
        
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //        print(#function)
        
        return 10
    }
    
    
}

class PhotosCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollDirection = .horizontal
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let currentOffset = self.collectionView!.contentOffset.x
        let targetRect = CGRect(x:currentOffset, y:0, width:self.collectionView!.bounds.size.width, height:self.collectionView!.bounds.size.height)
        
        if velocity.x == 0 {
            let horizontalOffset = proposedContentOffset.x
            for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
                let itemOffset = layoutAttributes.frame.origin.x
                if (abs(itemOffset - horizontalOffset) < abs(offsetAdjustment)) {
                    offsetAdjustment = itemOffset - horizontalOffset
                }
            }
            
            return CGPoint(x:proposedContentOffset.x + offsetAdjustment, y:proposedContentOffset.y)
        } else {
            let leftToRight = velocity.x > 0
            if let layoutAttributes = leftToRight ? super.layoutAttributesForElements(in: targetRect)?.last : super.layoutAttributesForElements(in: targetRect)?.first {
                let itemOffset = layoutAttributes.frame.origin.x
                if (abs(itemOffset - currentOffset) < abs(offsetAdjustment)) {
                    offsetAdjustment = itemOffset - currentOffset
                }
            }
        }
        
        return CGPoint(x:currentOffset + offsetAdjustment, y:proposedContentOffset.y)
    }
}
