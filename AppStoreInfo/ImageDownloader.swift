//
//  ImageDownloader.swift
//  AppStoreInfo
//
//  Created by Nisarg Mehta on 8/27/17.
//  Copyright © 2017 Open Source. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    var details: AppDetails?
    var sessionTask: URLSessionTask? = nil
    var completionHandler: ((Void)->Void)?
    
    func startDownload() {
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: NSURL(string: (self.details?.imageUrl)!) as! URL)
        self.sessionTask = session.dataTask(with: request as URLRequest){
            (data, response, error) -> Void in
            if error != nil {
                print("error in url")
            } else {
                let image = UIImage.init(data: data!)
                self.details?.iconImage = image
                self.completionHandler?()
            }
        }
        self.sessionTask?.resume()
    }
    
    func cancelDownload() {
        self.sessionTask?.cancel()
    }
}
