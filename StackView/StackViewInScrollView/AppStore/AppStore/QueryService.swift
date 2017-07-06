//
//  QueryService.swift
//  AppStore
//
//  Created by Jongwon Woo on 25/06/2017.
//  Copyright © 2017 WooJongwon. All rights reserved.
//

import Foundation

class QueryService {
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = (JSONDictionary?) -> ()
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getSearchResults(url: URL, completion: @escaping QueryResult) {
        dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            
            if error == nil {
                if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    let json = self.parse(data)
                    completion(json)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
        dataTask?.resume()
    }
    
    fileprivate func parse(_ data: Data) -> JSONDictionary? {
        var response: JSONDictionary?
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            print("JSONSerialization error: \(parseError.localizedDescription)")
            return nil
        }
        
        return response
    }
    
}
