//
//  ExUICollectionView.swift
//  LivePhotoPlayground
//
//  Created by jongwon woo on 2016. 11. 18..
//  Copyright © 2016년 jongwonwoo. All rights reserved.
//

import UIKit

extension UICollectionView {
    func indexPathForVisibleCenter() -> IndexPath? {
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return self.indexPathForItem(at: visiblePoint)
    }
}
