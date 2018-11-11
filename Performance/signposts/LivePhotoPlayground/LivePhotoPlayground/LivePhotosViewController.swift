//
//  LivePhotosViewController.swift
//  LivePhotoPlayground
//
//  Created by jongwon woo on 2016. 10. 21..
//  Copyright © 2016년 jongwonwoo. All rights reserved.
//

import UIKit
import Photos

import os.signpost

struct SignpostLog {
    static let cellForItem = OSLog(subsystem: "com.jongwonwoo.livephotoviewer", category: "cellForItem")
}


class CustomCollectionView: UICollectionView {
    
    var reloadDataCompletionBlock: (() -> Void)?
    
    func reloadDataWithCompletion(_ completion:@escaping () -> Void) {
        reloadDataCompletionBlock = completion
        super.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let block = self.reloadDataCompletionBlock {
            block()
        }
    }
}

class LivePhotosViewController: UICollectionViewController {
    fileprivate let reuseIdentifier = "LivePhotoCell"
    @IBOutlet weak var emptyMessageView: UIView!
    
    fileprivate let livePhotoFetcher = LivePhotoFetcher()
    fileprivate var livePhotos: PHFetchResult<PHAsset>? {
        didSet {
            if let count = livePhotos?.count {
                self.emptyMessageView.isHidden = count != 0
            } else {
                self.emptyMessageView.isHidden = false
            }
        }
    }
    
    fileprivate var indexPathForPlayingCell: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestPhotoLibraryAuthorization(authorized: { [unowned self] in
            DispatchQueue.main.async {
                
                self.fetchLivePhotos()
                guard let collectionView = self.collectionView as? CustomCollectionView else { return }
                collectionView.reloadDataWithCompletion {
                    collectionView.reloadDataCompletionBlock = nil
                }
                
                self.registerForLivePhotosDidChange()
            }
        }, denied: { [unowned self] in
            DispatchQueue.main.async {
                self.openSettings()
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive(notification:)) , name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appDidBecomeActive(notification: Notification?) {
        self.requestPhotoLibraryAuthorization(authorized: nil, denied: { [unowned self] in
            DispatchQueue.main.async {
                self.openSettings()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startPlaybackOfLivePhotoAtVisibleCells()
    }
}

extension LivePhotosViewController {
    fileprivate func requestPhotoLibraryAuthorization(authorized:(()->())?, denied:(()->())?) {
        PHPhotoLibrary.requestAuthorization({(status:PHAuthorizationStatus) in
            switch status{
            case .authorized:
                if let authorizedBind = authorized {
                    authorizedBind()
                }
            case .denied:
                if let deniedBind = denied {
                    deniedBind()
                }
            default:
                break
            }
        })
    }
    
    fileprivate func openSettings() {
        let alertController = UIAlertController (title: "This App Would Like to Access Your Photos", message: "Used to see live photos", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension LivePhotosViewController {
    fileprivate func fetchLivePhotos() {
        self.livePhotos = livePhotoFetcher.fetchLivePhotos()
    }
    
    fileprivate func registerForLivePhotosDidChange() {
        self.livePhotoFetcher.livePhotosDidChange { [unowned self] (livePhotos: PHFetchResult<PHAsset>?, changes: PHFetchResultChangeDetails<PHAsset>?) in
            DispatchQueue.main.async {                
                if let collectionChanges = changes {
                    self.livePhotos = livePhotos
                    
                    if !collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves {
                        self.collectionView?.reloadData()
                    } else {
                        self.collectionView?.performBatchUpdates({ [unowned self] in
                            if let removedIndexes = collectionChanges.removedIndexes {
                                if removedIndexes.count > 0 {
                                    self.collectionView?.deleteItems(at: self.indexPathsFromIndexes(removedIndexes))
                                }
                            }
                            
                            if let insertedIndexes = collectionChanges.insertedIndexes {
                                if insertedIndexes.count > 0 {
                                    self.collectionView?.insertItems(at: self.indexPathsFromIndexes(insertedIndexes))
                                }
                            }
                            
                            if let changedIndexes = collectionChanges.changedIndexes {
                                if changedIndexes.count > 0 {
                                    self.collectionView?.reloadItems(at: self.indexPathsFromIndexes(changedIndexes))
                                }
                            }
                            
                        }, completion: nil)
                    }
                }
            }
        }
    }
    
    private func indexPathsFromIndexes(_ indexes: IndexSet) -> [IndexPath] {
        return indexes.map { IndexPath.init(row: $0, section: 0) }
    }
}

// MARK: - UICollectionViewDataSource
extension LivePhotosViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0;
        
        if let livePhotos = self.livePhotos {
            count = livePhotos.count
        }
        
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let uuid = UUID.ReferenceType()
        let signpostId = OSSignpostID(log: SignpostLog.cellForItem, object: uuid)
        os_signpost(.begin, log: SignpostLog.cellForItem, name: "configure cell", signpostID: signpostId, "%@", indexPath.description)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LivePhotoCollectionViewCell
        
        if let livePhotos = self.livePhotos {
            let asset = livePhotos[indexPath.item]
            let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let itemSize = collectionViewLayout.itemSize
            let scale = UIScreen.main.scale
            let targetSize = CGSize.init(width: itemSize.width * scale, height: itemSize.height * scale)
            self.livePhotoFetcher.fetchLivePhoto(for: asset, targetSize: targetSize, contentMode: .aspectFill, prefferedLowQuality: false, completion: { livePhoto in
                DispatchQueue.main.async {
                    cell.livePhoto = livePhoto;
                    
                    os_signpost(.end, log: SignpostLog.cellForItem, name: "configure cell", signpostID: signpostId)
                }
            })
        }
        
        cell.indexPath = indexPath
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

// MARK: - UICollectionView delegate
extension LivePhotosViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - scrollview delegate
extension LivePhotosViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopPlayback()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            startPlaybackOfLivePhotoAtVisibleCells()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startPlaybackOfLivePhotoAtVisibleCells()
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        startPlaybackOfLivePhotoAtVisibleCells()
    }
    
    fileprivate func startPlaybackOfLivePhotoAtVisibleCells() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let indexPath = self.collectionView?.indexPathForVisibleCenter() {
                if let cell = self.collectionView?.cellForItem(at: indexPath) as? LivePhotoCollectionViewCell {
                    self.indexPathForPlayingCell = indexPath
                    cell.startPlayback()
                }
            }
        }
    }
    
    fileprivate func stopPlayback() {
        if let indexPath = self.indexPathForPlayingCell {
            if let cell = self.collectionView?.cellForItem(at: indexPath) as? LivePhotoCollectionViewCell {
                cell.stopPlayback()
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LivePhotosViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 1
        let paddingSpace = itemsPerRow + 1
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension LivePhotosViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLivePhotoDetail" {
            stopPlayback()
            
            guard let livePhotoViewController = segue.destination as? LivePhotoViewController,
                let indexPath = self.collectionView?.indexPathsForSelectedItems?.last,
                let livePhotos = self.livePhotos
                else { return }
            
            let livePhoto = livePhotos[indexPath.item]
            livePhotoViewController.livePhotoAsset = livePhoto
        }
    }
}
