//
//  ParseInfo.swift
//  AppStoreInfo
//
//  Created by Nisarg Mehta on 8/27/17.
//  Copyright © 2017 Open Source. All rights reserved.
//

protocol ParsingProtocol: class {
    func didGetData(data: NSMutableArray)
}

import Foundation

class ParseInfo {
    weak var delegate: ParsingProtocol?
    
    func getDataForKeyword(keyWord : NSString) {
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: NSURL(string: String(format: "https://itunes.apple.com/search?entity=software&term=%@&limit=50",keyWord)) as! URL)
        let task = session.dataTask(with: request as URLRequest){
            (data, response, error) -> Void in
            if error != nil {
                print("error in url")
            } else {
//                print(data!)
                do {
//                    let parsedData = try JSONSerialization.jsonObject(with: data! ) as! [String:Any]
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers])
                    let resultDict = parsedData as! NSDictionary
                    self.createAppDetailsArray(results: resultDict)
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func createAppDetailsArray(results: NSDictionary) {
        let allApps = NSMutableArray()
        let allResults = results.object(forKey: "results") as! NSArray
        for case let appDict as NSDictionary in allResults {
            let details = AppDetails()
            if let name = appDict.object(forKey: "trackName") {
                details.appName = name as? String
//                print(name)
            }
            if let desc = appDict.object(forKey: "description") {
                details.description = desc as? String
            }
            if let rate = appDict.object(forKey: "rating") {
                details.rating = rate as? Float
            }
            if let image = appDict.object(forKey: "artworkUrl512") {
                details.imageUrl = image as? String
            }
            if let version = appDict.object(forKey: "version") {
                details.appVersion = version as? String
            }
            allApps.add(details)
        }
        if (self.delegate != nil) {
            self.delegate?.didGetData(data: allApps)
        }
    }
}
