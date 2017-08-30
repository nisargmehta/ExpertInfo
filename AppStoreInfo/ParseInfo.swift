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
        let request = NSMutableURLRequest(url: NSURL(string: String(format: "https://itunes.apple.com/search?entity=software&term=%@&limit=1",keyWord)) as! URL)
        let task = session.dataTask(with: request as URLRequest){
            (data, response, error) -> Void in
            if error != nil {
                print("error in url")
            } else {
                print(data!)
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    print(parsedData)
//                    let currentTemperatureF = currentConditions["temperature"] as! Double
//                    print(currentTemperatureF)
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
