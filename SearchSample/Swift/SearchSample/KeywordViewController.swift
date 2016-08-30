//
//  KeywordViewcontroller.swift
//  SearchSample
//
//  Created by Itthisak Phueaksri on 5/14/2559 BE.
//  Copyright © 2559 gissoft. All rights reserved.
//

import UIKit
import NOSTRASDK

class KeywordViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var keywords: [NTAutocompleteResult]?;
    
    var param: NTAutocompleteParameter?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "keywordtoResultSegue" {
            let resultViewController = segue.destinationViewController as! ResultViewController;
            
            resultViewController.searchByKeyword(sender as? String);
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count > 0 {
            param = NTAutocompleteParameter(keyword: searchText);
            
            NTAutocompleteService.executeAsync(param!) { (resultSet, error) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    if error == nil {
                        self.keywords = resultSet.results;
                    }
                    else {
                        self.keywords = [];
                        print("error: \(error.description)");
                    }
                    self.tableView.reloadData();
                })
                
            }
        }
        
        
        
        
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder();
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let keyword = keywords![indexPath.row];
        self.performSegueWithIdentifier("keywordtoResultSegue", sender: keyword.name);
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell");
        let keyword = keywords![indexPath.row];
        
        cell?.textLabel?.text = keyword.name;
        
        return cell!;
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywords != nil ? (keywords?.count)! : 0;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
}
