//
//  PhotoCollectionViewCell.swift
//  LivePhotoPlayground
//
//  Created by jongwon woo on 2016. 10. 21..
//  Copyright © 2016년 jongwonwoo. All rights reserved.
//

import UIKit
import PhotosUI

class PhotoCollectionViewCell: UICollectionViewCell {
    private var photoView: ZoomablePhotoView?
    var indexPath: IndexPath?
    
    private let photoFetcher = PhotoFetcher()
    
    var asset: PHAsset? {
        didSet {
            guard let asset = asset else { return }
            
            let itemSize = contentView.frame.size
            let scale = UIScreen.main.scale
            let targetSize = CGSize.init(width: itemSize.width * scale, height: itemSize.height * scale)
            self.photoFetcher.fetchImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, completion: { image in
                DispatchQueue.main.async {
                    self.image = image;
                }
            })
        }
    }
    var image: UIImage? {
        didSet {
            if self.photoView == nil {
                makePhotoView()
            }
            
            self.photoView?.photo = image
        }
    }
    
    private func makePhotoView() {
        let photoView = ZoomablePhotoView.init(frame: CGRect.zero)
        photoView.delegate = self
        photoView.maximumZoomScale = 3.0
        photoView.backgroundColor = .clear
        photoView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(photoView)
        
        photoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        photoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
        photoView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        photoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        
        self.photoView = photoView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print(#function + " of cell \(self.indexPath!)")
        
        self.contentView.backgroundColor = .blue
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        image = nil
        asset = nil
        
        print(#function + " \(self.indexPath!)")
    }
}

extension PhotoCollectionViewCell: ZoomablePhotoViewDelegate {
    func zoomablePhotoViewWillBeginZooming(_ view: ZoomablePhotoView) {
    }
    
    func zoomablePhotoViewDidEndZooming(_ view: ZoomablePhotoView, atScale scale: CGFloat) {
    }
}
