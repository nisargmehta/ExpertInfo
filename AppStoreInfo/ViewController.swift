//
//  ViewController.swift
//  AppStoreInfo
//
//  Created by Nisarg Mehta on 8/27/17.
//  Copyright © 2017 Open Source. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, ParsingProtocol {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var appInfoTableView: UITableView!
    
    var isLoading: Bool = false
    var parse: ParseInfo?
    
    lazy var downloadsInProgress: NSMutableDictionary = {
        return NSMutableDictionary()
    }()
    
    lazy var allEnteries: NSMutableArray = {
        return NSMutableArray()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.parse = ParseInfo()
        self.parse?.delegate = self
        
        self.searchBar.delegate = self
        
        self.appInfoTableView.delegate = self;
        self.appInfoTableView.dataSource = self;
//        self.present(self, animated: false, completion: nil)
        
//        self.appInfoTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
//        self.appInfoTableView.register(UINib(nibName: "CustomCellView", bundle: nil), forCellReuseIdentifier: "appCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Protocol
    func didGetData(data: NSMutableArray) {
        self.allEnteries = data
        DispatchQueue.main.async{
            self.isLoading = false;
            self.appInfoTableView.reloadData()
        }
    }
    
    // MARK: IBActions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (self.searchBar.text?.characters.count)! > 0 {
            self.isLoading = true
            self.searchBar.resignFirstResponder()
            self.parse?.getDataForKeyword(keyWord: self.searchBar.text! as NSString)
        }
    }
    
    // MARK: Tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsVC") as! DetailsViewController
        detailsVC.details = self.allEnteries.object(at: indexPath.row) as? AppDetails
        self.navigationController?.pushViewController(detailsVC, animated: true)
//        self.present(detailsVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "appCell") as? CustomTableViewCell
        if cell == nil {
            let nibArray = Bundle.main.loadNibNamed("CustomCellView", owner: nil, options: nil)! as NSArray
            cell = (nibArray.object(at: 0) as! CustomTableViewCell)
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        let details: AppDetails = self.allEnteries.object(at: indexPath.row) as! AppDetails
//        cell.textLabel?.text = details.appName
        cell?.theNameLabel.text = details.appName
        if let rating = details.rating {
           cell?.ratingLabel.text = String(format: "%.1f", rating)
        } else {
            cell?.ratingLabel.text = "n/a"
        }
        if let icon = details.iconImage {
            cell?.theImageView.image = icon
        } else {
            self.startImageDownload(details: details, index: indexPath)
            cell?.theImageView.image = UIImage.init(named: "placeholder.png")
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allEnteries.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func startImageDownload(details: AppDetails, index: IndexPath) {
        if self.downloadsInProgress.object(forKey: index) != nil {
            print("in progress")
        } else {
            let downloader = ImageDownloader()
            downloader.details = details
            downloader.completionHandler = {
                DispatchQueue.main.async {
                    let theCell: CustomTableViewCell = self.appInfoTableView.cellForRow(at: index)! as! CustomTableViewCell
                    theCell.theImageView.image = details.iconImage
                    self.downloadsInProgress.removeObject(forKey: index)
                }
            }
            self.downloadsInProgress.setObject(downloader, forKey: index as NSCopying)
            downloader.startDownload()
        }
    }
}

