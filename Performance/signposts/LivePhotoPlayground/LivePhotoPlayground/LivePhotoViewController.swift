//
//  LivePhotoViewController.swift
//  LivePhotoPlayground
//
//  Created by jongwon woo on 2016. 10. 28..
//  Copyright © 2016년 jongwonwoo. All rights reserved.
//

import UIKit
import PhotosUI

class LivePhotoViewController: UIViewController, PHLivePhotoViewDelegate {
    
    @IBOutlet weak var contentView: UIView!
    fileprivate weak var livePhotoView: PHLivePhotoView!
    private var forcelyStoppedPlayback: Bool = false
    
    private let livePhotoFetcher = LivePhotoFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeLivePhotoView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startPlayback()
    }
    
    private func makeLivePhotoView() {
        let livePhotoView = PHLivePhotoView.init(frame: self.contentView.bounds)
        livePhotoView.contentMode = .scaleAspectFit
        livePhotoView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(livePhotoView)
        livePhotoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        livePhotoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
        livePhotoView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        livePhotoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        self.livePhotoView = livePhotoView
        
        self.livePhotoView.delegate = self
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
    
    var livePhotoAsset: PHAsset? {
        didSet {
            let scale = UIScreen.main.scale
            let targetSize = CGSize.init(width: self.view.frame.size.width * scale, height: self.view.frame.size.height * scale)
            if let asset = livePhotoAsset {
                if let creationDate = asset.creationDate {
                    self.showTitle(date: creationDate)
                }
                
                self.livePhotoFetcher.fetchLivePhoto(for: asset, targetSize: targetSize, contentMode: .aspectFit, completion: { [unowned self] (livePhoto) in
                    self.livePhoto = livePhoto;
                })
            }
        }
    }
    
    var livePhoto: PHLivePhoto? {
        didSet {
            DispatchQueue.main.async {
                self.livePhotoView.livePhoto = self.livePhoto                
                self.startPlayback()
            }
        }
    }
    
    func startPlayback() {
        self.forcelyStoppedPlayback = false
        self.livePhotoView?.startPlayback(with: .full)
    }
    
    func stopPlayback() {
        self.forcelyStoppedPlayback = true
        self.livePhotoView?.stopPlayback()
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        if self.forcelyStoppedPlayback == false {
            self.startPlayback()
        }
    }
}
