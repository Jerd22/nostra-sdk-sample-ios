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
    
    func searchByKeyword(_ keyword: String!) {
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
    
    func searchByCategory(_ category: String!) {
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
    
    func searchByLocalCategory(_ localCategory: String!) {
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
    
    
    func searchWithParam(_ param: NTLocationSearchParameter) {
        NTLocationSearchService.executeAsync(param, Completion: { (resultSet, error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    self.results = resultSet?.results;
                }
                else {
                    self.results = [];
                    print("error: \(error?.description)");
                }
                self.tableView.reloadData();
            })
            
        });
    }
    
    
    func performUnabletoSearch() {
        let alertController = UIAlertController(title: "Unable to search", message: "Please check your location.", preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            _ = self.navigationController?.popViewController(animated: true);
        }));
        
        self.present(alertController, animated: true, completion: nil);
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapResultSegue" {
            let mapResultViewController = segue.destination as? MapResultViewController;
            mapResultViewController?.result = sender as! NTLocationSearchResult;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let result = results![indexPath.row];
        self.performSegue(withIdentifier: "mapResultSegue", sender: result);
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        let result = results![indexPath.row];
        
        cell?.textLabel?.text = result.name_L;
        cell?.detailTextLabel?.text = "\(result.adminLevel3_L), \(result.adminLevel2_L), \(result.adminLevel1_L)"
        
        return cell!;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results != nil ? (results?.count)! : 0;
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
}
