//
//  DetailsViewController.swift
//  AppStoreInfo
//
//  Created by Nisarg Mehta on 8/27/17.
//  Copyright © 2017 Open Source. All rights reserved.
//

/*
 // Define identifier
 let notificationName = Notification.Name("NotificationIdentifier")
 
 // Register to receive notification
 NotificationCenter.default.addObserver(self, selector: #selector(YourClassName.methodOfReceivedNotification), name: notificationName, object: nil)
 
 // Post notification
 NotificationCenter.default.post(name: notificationName, object: nil)
 
 // Stop listening notification
 NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);
 */

import Foundation
import UIKit

class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var screenShotsCollection: UICollectionView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    private var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var details: AppDetails?
    var isFetching: Bool = true
    
    lazy var allImages: NSMutableArray = {
        return NSMutableArray()
    }()
    
    override func viewDidLoad() {
        self.descriptionTextView.text = self.details?.description
        
        self.screenShotsCollection.delegate = self
        self.screenShotsCollection.dataSource = self
        self.screenShotsCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.details?.screenShotUrls?.count)! > 0 {
            self.isFetching = true
            self.populateImages()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleRotation(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            self.setUIForPortrait()
        } else {
            self.setUIForLandscape()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func populateImages() {
        let session = URLSession.shared
        for imageUrl in (self.details?.screenShotUrls)! {
            let request = NSMutableURLRequest(url: NSURL(string: imageUrl as! String) as! URL)
            let sessionTask = session.dataTask(with: request as URLRequest){
                (data, response, error) -> Void in
                if error != nil {
                    print("error in url")
                } else {
                    let image = UIImage.init(data: data!)
//                    UIGraphicsBeginImageContext(CGSize(width:180,height:300))
//                    image?.draw(in: CGRect(x: 0.0, y: 0.0, width: 180, height: 300))
//                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    self.allImages.add(image!)
//                    UIGraphicsEndImageContext()
                    if self.allImages.count == self.details?.screenShotUrls?.count {
                        DispatchQueue.main.async{
                            self.isFetching = false
                            self.screenShotsCollection.reloadData()
                        }
                    }
                }
            }
            sessionTask.resume()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.gray
        let screen: UIImage = (self.allImages.object(at: indexPath.row) as? UIImage)!
        let newImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 300))
        newImageView.image = screen
        cell.contentView.addSubview(newImageView)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isFetching ? 0 : self.allImages.count
    }
    
    func handleRotation(notification: NSNotification) {
        screenWidth = UIScreen.main.bounds.width
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            self.setUIForPortrait()
        } else {
            self.setUIForLandscape()
        }
    }
    
    func setUIForPortrait() {
        self.screenShotsCollection.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 370)
        self.descriptionTextView.frame = CGRect(x: 10, y: 390, width: screenWidth-2*10, height: 270)
    }
    
    func setUIForLandscape() {
        self.screenShotsCollection.frame = CGRect(x: 0, y: 0, width: screenWidth/2, height: 375)
        self.descriptionTextView.frame = CGRect(x: screenWidth/2 + 10, y: 20, width: screenWidth/2-2*10, height: 375-40)
    }
}
