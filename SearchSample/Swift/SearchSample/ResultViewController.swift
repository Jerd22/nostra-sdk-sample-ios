//
//  ResultViewController.swift
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK
import CoreLocation

class ResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var results: [NTLocationSearchResult]?;
    let locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D! = nil;
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // For use in foreground
        coordinate = self.locationManager.location?.coordinate;
        
    }
    
    func searchByKeyword(keyword: String!) {
        if keyword != nil && coordinate != nil {
            let param = NTLocationSearchParameter(keyword: keyword,
                                                  lat: (coordinate?.latitude)!,
                                                  lon: (coordinate?.longitude)!);
            self.searchWithParam(param);
        }
        else {
            self.performUnabletoSearch();
        }
    }
    
    func searchByCategory(category: String!) {
        if category != nil && coordinate != nil {
            
            let param = NTLocationSearchParameter(categoryCode: [category],
                                                  lat: (coordinate?.latitude)!,
                                                  lon: (coordinate?.longitude)!);
            

            self.searchWithParam(param);
        }
        else {
            self.performUnabletoSearch();
        }

    }
    
    func searchByLocalCategory(localCategory: String!) {
        if localCategory != nil && coordinate != nil {
            
            
            let param = NTLocationSearchParameter(localCategoryCode: [localCategory],
                                                  lat: (coordinate?.latitude)!,
                                                  lon: (coordinate?.longitude)!);
            
            
            self.searchWithParam(param);
        }
        else {
            self.performUnabletoSearch();
        }
    }
    
    
    func searchWithParam(param: NTLocationSearchParameter) {
        NTLocationSearchService.executeAsync(param, Completion: { (resultSet, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if error == nil {
                    self.results = resultSet.results;
                }
                else {
                    self.results = [];
                    print("error: \(error.description)");
                }
                self.tableView.reloadData();
            })
            
        });
    }
    
    
    func performUnabletoSearch() {
        let alertController = UIAlertController(title: "Unable to search", message: "Please check your location.", preferredStyle: .Alert);
        alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action) in
            self.navigationController?.popViewControllerAnimated(true);
        }));
        
        self.presentViewController(alertController, animated: true, completion: nil);
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapResultSegue" {
            let mapResultViewController = segue.destinationViewController as? MapResultViewController;
            mapResultViewController?.result = sender as! NTLocationSearchResult;
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let result = results![indexPath.row];
        self.performSegueWithIdentifier("mapResultSegue", sender: result);
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell");
        let result = results![indexPath.row];
        
        cell?.textLabel?.text = result.name_L;
        cell?.detailTextLabel?.text = "\(result.adminLevel3_L), \(result.adminLevel2_L), \(result.adminLevel1_L)"
        
        return cell!;
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results != nil ? (results?.count)! : 0;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
}
