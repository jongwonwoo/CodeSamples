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
    private var photoView: UIImageView?
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
            
            self.photoView?.image = image
        }
    }
    
    private func makePhotoView() {
        let photoView = UIImageView.init(frame: self.contentView.bounds)
        photoView.contentMode = .scaleAspectFill
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        image = nil
        asset = nil
        
        print(#function + " \(self.indexPath!)")
    }
}
