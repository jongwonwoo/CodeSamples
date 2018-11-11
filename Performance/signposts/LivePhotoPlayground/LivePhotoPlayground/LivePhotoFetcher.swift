//
//  LivePhotoFetcher.swift
//  LivePhotoPlayground
//
//  Created by jongwon woo on 2016. 11. 4..
//  Copyright © 2016년 jongwonwoo. All rights reserved.
//

import UIKit
import Photos

class LivePhotoFetcher: NSObject, PHPhotoLibraryChangeObserver {
    fileprivate let imageManager = PHImageManager()
    var fetchResult: PHFetchResult<PHAsset>?
    var changeHandler: ((PHFetchResult<PHAsset>?, PHFetchResultChangeDetails<PHAsset>?) -> Void)?

    public override init() {
        super.init()
        
        PHPhotoLibrary.shared().register(self)
    }
    
    func fetchLivePhotos() -> PHFetchResult<PHAsset>? {
        let options = PHFetchOptions()
        options.predicate = NSPredicate.init(format: "(mediaSubtype & %d) != 0", PHAssetMediaSubtype.photoLive.rawValue)
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(with: options)
        
        return self.fetchResult
    }
    
    func fetchLivePhoto(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, completion: @escaping (PHLivePhoto?) -> Swift.Void) {
        fetchLivePhoto(for: asset, targetSize: targetSize, contentMode: contentMode, prefferedLowQuality: false, completion: completion)
    }
    
    func fetchLivePhoto(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, prefferedLowQuality: Bool, completion: @escaping (PHLivePhoto?) -> Swift.Void) {
        let options = PHLivePhotoRequestOptions()
        options.deliveryMode = prefferedLowQuality ? .fastFormat : .highQualityFormat
        self.imageManager.requestLivePhoto(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: { (result, info) in
            completion(result)
        })
    }
    
    func livePhotosDidChange(_ handler: @escaping (PHFetchResult<PHAsset>?, PHFetchResultChangeDetails<PHAsset>?) -> Void) {
        self.changeHandler = handler
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let handler = self.changeHandler,
            let fetchResult = self.fetchResult
            else { return }
        
        DispatchQueue.main.async {
            if let collectionChanges = changeInstance.changeDetails(for: fetchResult) {
                self.fetchResult = collectionChanges.fetchResultAfterChanges
                
                handler(self.fetchResult, collectionChanges)
            }
        }
    }
}
