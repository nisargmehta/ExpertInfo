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
        
        self.appInfoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let details: AppDetails = self.allEnteries.object(at: indexPath.row) as! AppDetails
        cell.textLabel?.text = details.appName
        cell.detailTextLabel?.text = String(format: "%.1f", details.rating!)
        if let icon = details.iconImage {
            cell.imageView?.image = icon
        } else {
            self.startImageDownload(details: details, index: indexPath)
            cell.imageView?.image = UIImage.init(named: "placeholder.png")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allEnteries.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func startImageDownload(details: AppDetails, index: IndexPath) {
        let downloader = ImageDownloader()
        downloader.details = details
        downloader.completionHandler = {
            DispatchQueue.main.async {
                let theCell: UITableViewCell = self.appInfoTableView.cellForRow(at: index)!
                theCell.imageView?.image = details.iconImage
            }
        }
        downloader.startDownload()
    }
}

