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
    
    @IBOutlet weak var contentView: UIView!
    fileprivate weak var photoView: UIImageView!
    private var forcelyStoppedPlayback: Bool = false
    
    private let photoFetcher = PhotoFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeLivePhotoView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func makeLivePhotoView() {
        let photoView = UIImageView.init(frame: self.contentView.bounds)
        photoView.contentMode = .scaleAspectFit
        photoView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(photoView)
        photoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        photoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
        photoView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        photoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        self.photoView = photoView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func showTitle(date: Date?) {
        guard let dateBind = date else { return }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        self.title = formatter.string(from: dateBind)
    }
    
    var asset: PHAsset? {
        didSet {
            let scale = UIScreen.main.scale
            let targetSize = CGSize.init(width: self.view.frame.size.width * scale, height: self.view.frame.size.height * scale)
            if let asset = asset {
                if let creationDate = asset.creationDate {
                    self.showTitle(date: creationDate)
                }
                
                self.photoFetcher.fetchImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, completion: { [unowned self] (livePhoto) in
                    self.photo = livePhoto;
                })
            }
        }
    }
    
    var photo: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.photoView.image = self.photo
            }
        }
    }
}
