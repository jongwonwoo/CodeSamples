//
//  ZoomablePhotoView.swift
//  ZoomablePhotoViewDemo
//
//  Created by Jongwon Woo on 14/03/2017.
//  Copyright © 2017 jongwonwoo. All rights reserved.
//

import UIKit
import PhotosUI

@objc protocol ZoomablePhotoViewDelegate {
    @objc optional func zoomablePhotoViewWillBeginZooming(_ view: ZoomablePhotoView)
    @objc optional func zoomablePhotoViewDidEndZooming(_ view: ZoomablePhotoView, atScale scale: CGFloat)
}

open class ZoomablePhotoView: UIView {

    weak var delegate: ZoomablePhotoViewDelegate?
    
    private var view: UIView!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    fileprivate weak var photoView: UIImageView!

    fileprivate var centerPoint: CGPoint = CGPoint.zero
    
    open var zoomScale: CGFloat {
        return scrollView.zoomScale
    }
    
    open var maximumZoomScale: CGFloat = 1.0 {
        didSet {
            self.scrollView.maximumZoomScale = maximumZoomScale
            if zoomScale > maximumZoomScale {
                self.scrollView.zoomScale = maximumZoomScale
            }
        }
    }
    
    open var photo: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.photoView.image = self.photo
                if let photo = self.photo {
                    self.photoView.transform = .identity
                    self.photoView.frame = CGRect(x: 0, y: 0, width: photo.size.width, height: photo.size.height)
                }
                self.scrollView.contentSize = self.photoView.bounds.size

                self.setZoomParametersForSize(self.scrollView.bounds.size)
                self.scrollView.zoomScale = self.scrollView.minimumZoomScale
                self.recenterImage()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        self.makePhotoView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.orientationWillChange(notification:)),
                                               name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "\(ZoomablePhotoView.self)", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    private func makePhotoView() {
        self.photoView?.removeFromSuperview()
        
        let photoView = UIImageView.init(frame: CGRect.zero)
        photoView.backgroundColor = .clear
        photoView.contentMode = .scaleAspectFit
        self.photoView = photoView
        
        self.scrollView.addSubview(photoView)
    }
}

extension ZoomablePhotoView {
    func orientationWillChange(notification: Notification) {
        centerPoint = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.width / 2,
                              y: scrollView.contentOffset.y + scrollView.bounds.height / 2)
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // TODO: contentOffset 적용 후에 여백이 생기는 문제
        self.scrollView.contentOffset = CGPoint(x: centerPoint.x - self.frame.size.width / 2,
                                                y: centerPoint.y - self.frame.size.height / 2)
        
        setZoomParametersForSize(self.scrollView.bounds.size)
        if self.scrollView.zoomScale < self.scrollView.minimumZoomScale {
            self.scrollView.zoomScale = self.scrollView.minimumZoomScale
        }
        self.recenterImage()
    }
    
    fileprivate func setZoomParametersForSize(_ scrollViewSize: CGSize) {
        let imageSize = self.photoView.bounds.size
        
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = self.maximumZoomScale
    }
    
    fileprivate func recenterImage() {
        let scrollViewSize = self.scrollView.bounds.size
        let imageSize = self.photoView.frame.size
        
        let horizontalSpace = imageSize.width < scrollViewSize.width ?
            (scrollViewSize.width - imageSize.width) / 2 : 0
        let verticalSpace = imageSize.height < scrollViewSize.height ?
            (scrollViewSize.height - imageSize.height) / 2 : 0
        
        self.scrollView.contentInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
    }
}

extension ZoomablePhotoView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoView
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegate?.zoomablePhotoViewWillBeginZooming?(self)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.recenterImage()
        delegate?.zoomablePhotoViewDidEndZooming?(self, atScale: scale)
    }
}
