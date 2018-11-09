//
//  ViewController.swift
//  SmoothScrolling
//
//  Created by Jongwon Woo on 27/06/2018.
//  Copyright © 2018 jongwonwoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var pageIndicator: UIPageControl!
    let itemCount = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cvFrame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 150)
        collectionView = UICollectionView(frame: cvFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        self.view.addSubview(collectionView)
        
        collectionView.register(RainbowCell.self, forCellWithReuseIdentifier: RainbowCell.identifier)
        collectionView.register(RedCell.self, forCellWithReuseIdentifier: RedCell.identifier)
        collectionView.register(MyFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "MyFooter")

        collectionView.dataSource = self
        collectionView.delegate = self
        
        pageIndicator = UIPageControl(frame: CGRect(x: 0, y: collectionView.frame.maxY + 10, width: self.view.frame.width, height: 30));
        pageIndicator.numberOfPages = itemCount
        pageIndicator.pageIndicatorTintColor = .red
        pageIndicator.currentPageIndicatorTintColor = .blue
        pageIndicator.currentPage = 0
        self.view.addSubview(pageIndicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let index = Int(currentOffset / width)
        
        if (Int(currentOffset) % Int(width) == 0) {
            self.pageIndicator.currentPage = index
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(String.init(format: "cellForItemAt #%i", indexPath.item))
        
        let identifier = RedCell.identifier
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RainbowCell
        cell.indexPath = indexPath
        cell.configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print(String.init(format: "viewForSupplementaryElement at #%i", indexPath.item))
        
        var reusableView: UICollectionReusableView?
        if (kind == UICollectionElementKindSectionFooter) {
            let footerView: MyFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "MyFooter", for: indexPath) as! MyFooterView
            reusableView = footerView
        }
        
        return reusableView!
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print(String.init(format: "sizeForItemAt #%i", indexPath.item))
        
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        print(String.init(format: "minimumLineSpacingForSectionAt #%i", section))
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        print(String.init(format: "minimumInteritemSpacingForSectionAt #%i", section))
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        print(String.init(format: "insetForSectionAt #%i", section))
        
        return UIEdgeInsets.init(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: collectionView.bounds.size.height)
    }
}


class MyFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("MyFooterView")
        
        self.backgroundColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

