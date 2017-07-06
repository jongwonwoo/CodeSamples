//
//  AppQueryService.swift
//  AppStore
//
//  Created by Jongwon Woo on 25/06/2017.
//  Copyright © 2017 WooJongwon. All rights reserved.
//

import Foundation

class AppQueryService {
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = (AppDetailInfo?) -> ()
    
    let queryService = QueryService()
    
    func getSearchResults(appId: String, completion: @escaping QueryResult) {
        if let url = URL(string: "https://itunes.apple.com/lookup?id=\(appId)&country=kr") {
            queryService.getSearchResults(url: url) { results in
                if let results = results {
                    let detailInfo = self.getAppDetailInfo(results)
                    
                    DispatchQueue.main.async {
                        completion(detailInfo)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    fileprivate func getAppDetailInfo(_ response: JSONDictionary) -> AppDetailInfo? {
        guard let array = response["results"] as? [Any], array.count > 0 else {
            print("Dictionary does not contain results key")
            return nil
        }
        
        if let appDictionary = array.first {
            if let appDictionary = appDictionary as? JSONDictionary,
                let description = appDictionary["description"] as? String,
                let releaseNotes = appDictionary["releaseNotes"] as? String,
                let screenshotUrlsArray = appDictionary["screenshotUrls"] as? [String],
                let userRating = appDictionary["averageUserRatingForCurrentVersion"] as? Float
                {
                return AppDetailInfo(screenshotUrls: screenshotUrlsArray, description: description, releaseNotes: releaseNotes, userRating:userRating)
            } else {
                print("Problem parsing appDictionary")
            }
        }
        
        return nil
    }
    
}
