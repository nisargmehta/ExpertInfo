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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Protocol
    func didGetData(data: NSMutableArray) {
        
    }
    
    // MARK: IBActions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.parse?.getDataForKeyword(keyWord: self.searchBar.text! as NSString)
    }
    
    // MARK: Tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allEnteries.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

