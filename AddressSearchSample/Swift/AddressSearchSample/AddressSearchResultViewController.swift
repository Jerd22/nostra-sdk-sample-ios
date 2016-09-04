//
//  AddressSearchResultViewController.swift
//  AddressSearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK

class AddressSearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var results: [NTAddressSearchResult]! = nil;
    var addressSearchParam: NTAddressSearchParameter! = nil;
    
    override func viewDidLoad() {
        
        if addressSearchParam != nil {
            NTAddressSearchService.executeAsync(addressSearchParam) {
                (resultSet, error) in
                if error == nil {
                    self.results = resultSet.results;
                    self.tableView.reloadData();
                }
                else {
                    print("error: \(error.localizedDescription)")
                }
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapViewSegue" {
            let mapResultViewController = segue.destinationViewController as? AddressSearchMapResultViewController;
            mapResultViewController!.result = (sender as! NTAddressSearchResult);
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let result = results[indexPath.row];
        self.performSegueWithIdentifier("mapViewSegue", sender: result)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell");
        let result = results[indexPath.row];
        
        cell?.textLabel?.text = "\(result.houseNo), \(result.soi_L)";
        cell?.detailTextLabel?.text = "\(result.adminLevel3_L), \(result.adminLevel2_L), \(result.adminLevel1_L)"
        
        return cell!;
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results != nil ? results.count : 0;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
}
