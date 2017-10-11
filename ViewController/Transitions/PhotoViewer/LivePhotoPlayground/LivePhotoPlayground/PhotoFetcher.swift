//
//  PhotoFetcher.swift
//  LivePhotoPlayground
//
//  Created by jongwon woo on 2016. 11. 4..
//  Copyright © 2016년 jongwonwoo. All rights reserved.
//

import UIKit
import Photos

class PhotoFetcher: NSObject, PHPhotoLibraryChangeObserver {
    fileprivate let imageManager = PHImageManager()
    var fetchResult: PHFetchResult<PHAsset>?
    var changeHandler: ((PHFetchResult<PHAsset>?, PHFetchResultChangeDetails<PHAsset>?) -> Void)?

    public override init() {
        super.init()
        
        PHPhotoLibrary.shared().register(self)
    }
    
    func fetchPhotos() -> PHFetchResult<PHAsset>? {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(with: options)
        
        return self.fetchResult
    }
    
    func fetchImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, completion: @escaping (UIImage?) -> Swift.Void) {
        let options = PHImageRequestOptions()
        self.imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: { (result, info) in
            completion(result)
        })
    }
    
    func photosDidChange(_ handler: @escaping (PHFetchResult<PHAsset>?, PHFetchResultChangeDetails<PHAsset>?) -> Void) {
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
