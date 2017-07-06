//
//  AsyncUIImageView.swift
//  AppStore
//
//  Created by Jongwon Woo on 25/06/2017.
//  Copyright © 2017 WooJongwon. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImage(url: URL){
        let req = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60);
        let conf =  URLSessionConfiguration.default;
        let session = URLSession(configuration: conf, delegate: nil, delegateQueue: OperationQueue.main);
        
        session.dataTask(with: req, completionHandler: { (data, resp, err) in
            if (err == nil) {
                if let data = data {
                    let image = UIImage(data:data)
                    self.image = image;
                } else {
                    self.image = nil
                }
            } else {
                print("Error \(String(describing: err?.localizedDescription))");
            }
        }).resume();
    }
}
