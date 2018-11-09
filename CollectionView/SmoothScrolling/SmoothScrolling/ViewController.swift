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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        collectionView.register(RainbowCell.self, forCellWithReuseIdentifier: RainbowCell.identifier)
        collectionView.register(RedCell.self, forCellWithReuseIdentifier: RedCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(String.init(format: "cellForItemAt #%i", indexPath.item))
        
        var identifier = RainbowCell.identifier
        switch indexPath.item % 7 {
        case 0:
            identifier = RedCell.identifier
        default:
            break
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RainbowCell
        cell.indexPath = indexPath
        cell.configure()
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print(String.init(format: "sizeForItemAt #%i", indexPath.item))
        
        var height = RainbowCell.height;
        switch indexPath.item % 7 {
        case 0:
            height = RedCell.height
        default:
            break
        }
        return CGSize(width: collectionView.bounds.size.width - 16, height: height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        print(String.init(format: "minimumLineSpacingForSectionAt #%i", section))
        
        return 8
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
        
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
}


