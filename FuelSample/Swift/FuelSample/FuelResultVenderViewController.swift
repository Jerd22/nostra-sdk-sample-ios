//
//  FuelResultViewController.swift
//  FuelSample
//
//  Created by Itthisak Phueaksri on 5/15/2559 BE.
//  Copyright © 2559 gissoft. All rights reserved.
//

import UIKit
import NOSTRASDK

class FuelResultVendorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var adminLevel1: String?;
    var adminLevel2: String?;
    
    var lat: Double?;
    var lon: Double?;
    
    var results: [NTFuelResult]?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        var param: NTFuelParameter! = nil;
        
        if adminLevel1 != nil && adminLevel2 != nil {
            param = NTFuelParameter(adminLevel1: adminLevel1!, adminLevel2: adminLevel2!);
        }
        else {
            param = NTFuelParameter(lat: lat!, lon: lon!);
        }
        
        do {
            let resultSet = try NTFuelService.execute(param);
            results = resultSet.results;
        }
        catch let error as NSError {
            print("error: \(error.description)");
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "priceSegue" {
            let priceViewController = segue.destinationViewController as? FuelResultPriceViewController;
            let result = sender as! NTFuelResult;
            priceViewController?.title = result.brandName_L;
            priceViewController?.result = result
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let result = results![indexPath.row];
        
        self.performSegueWithIdentifier("priceSegue", sender: result);
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell");
        let result = results![indexPath.row];
        
        cell?.textLabel?.text = result.brandName_L;
        
        
        return cell!;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results != nil ? (results?.count)! : 0;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
}
