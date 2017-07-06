//
//  AppListQueryService.swift
//  AppStore
//
//  Created by Jongwon Woo on 25/06/2017.
//  Copyright © 2017 WooJongwon. All rights reserved.
//

import Foundation

class AppListQueryService {
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([AppInfo]) -> ()
    
    let queryService = QueryService()
    
    func getSearchResults(completion: @escaping QueryResult) {
        if let url = URL(string: "https://itunes.apple.com/kr/rss/topfreeapplications/limit=50/genre=6015/json") {
            queryService.getSearchResults(url: url) { results in
                if let results = results {
                    let apps = self.getAppInfoList(results)
                    
                    DispatchQueue.main.async {
                        completion(apps)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            }
        }
    }
    
    fileprivate func getAppInfoList(_ response: JSONDictionary) -> [AppInfo] {
        var apps: [AppInfo] = []
        
        guard let feedDic = response["feed"] as? JSONDictionary,
            let array = feedDic["entry"] as? [Any] else {
            print("Dictionary does not contain required keys")
            return []
        }
        
        for appDictionary in array {
            if let appDictionary = appDictionary as? JSONDictionary,
                let nameDic = appDictionary["im:name"] as? JSONDictionary,
                let name = nameDic["label"] as? String,
                let iconArray = appDictionary["im:image"] as? [Any],
                iconArray.count > 0,
                let firstIconDic = iconArray.first as? JSONDictionary,
                let iconUrlString = firstIconDic["label"] as? String,
                let iconUrl = URL(string: iconUrlString),
                let sellerDic = appDictionary["im:artist"] as? JSONDictionary,
                let seller = sellerDic["label"] as? String,
                let idDic = appDictionary["id"] as? JSONDictionary,
                let idAttributesDic = idDic["attributes"] as? JSONDictionary,
                let id = idAttributesDic["im:id"] as? String {
                apps.append(AppInfo(name: name, identifier:id, iconUrl: iconUrl, sellerName: seller))
            } else {
                print("Problem parsing appDictionary")
            }
        }
        
        return apps
    }
    
}
