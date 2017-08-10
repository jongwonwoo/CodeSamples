//
//  LivePhotoCollectionViewCell.swift
//  LivePhotoPlayground
//
//  Created by jongwon woo on 2016. 10. 21..
//  Copyright © 2016년 jongwonwoo. All rights reserved.
//

import UIKit
import PhotosUI

class LivePhotoCollectionViewCell: UICollectionViewCell {
    private var livePhotoView: PHLivePhotoView?
    
    var livePhoto: PHLivePhoto? {
        didSet {
            if self.livePhotoView == nil {
                makeLivePhotoView()
            }
            
            self.livePhotoView?.livePhoto = livePhoto
        }
    }
    
    private func makeLivePhotoView() {
        let livePhotoView = PHLivePhotoView.init(frame: self.contentView.bounds)
        livePhotoView.contentMode = .scaleAspectFill
        livePhotoView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(livePhotoView)
        livePhotoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        livePhotoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
        livePhotoView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        livePhotoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        self.livePhotoView = livePhotoView
    }
    
    func startPlayback() {
        self.livePhotoView?.startPlayback(with: .full)
    }
    
    func stopPlayback() {
        self.livePhotoView?.stopPlayback()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print(#function + " of cell")
    }
}
