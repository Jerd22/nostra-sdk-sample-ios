//
//  ViewController.swift
//  DynamicContentSample
//
//  Created by Itthisak Phueaksri on 5/15/2559 BE.
//  Copyright © 2559 gissoft. All rights reserved.
//

import UIKit
import ArcGIS
import NOSTRASDK

class MainDMCViewController: UIViewController, AGSMapViewLayerDelegate, AGSLayerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var mapView: AGSMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnHideMenu: UIButton!
    
    @IBOutlet weak var tableLeading: NSLayoutConstraint!
    
    var results: [NTDynamicContentListResult]! = nil;
    
    
    let referrer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializeMap();

        do {
            let resultSet = try NTDynamicContentListService.execute();
            results = resultSet.results;
        }
        catch {
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "maintoDMCListSegue" {
            let dmcListViewController = segue.destinationViewController as! DMCListViewController;
            
            dmcListViewController.dmcResult = sender as! NTDynamicContentListResult;
            
        }
    }
    
    @IBAction func btnLayerMenu_Clicked(sender: AnyObject) {
        
        if tableLeading.constant == 0 {
            self.btnHideLayer_Clicked(sender);
            
            btnHideMenu.hidden = true;
        }
        else {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.75)
            tableLeading.constant = 0;
            UIView.commitAnimations();
            btnHideMenu.hidden = false;
        }
        
    }
    
    @IBAction func btnHideLayer_Clicked(sender: AnyObject) {
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.75)
        tableLeading.constant = -180;
        UIView.commitAnimations();
        

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let result = results[indexPath.row];
        self.performSegueWithIdentifier("maintoDMCListSegue", sender: result);
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell");
        
        let result = results[indexPath.row];
        
        cell?.textLabel?.text = result.name_L
        
        return cell!;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results != nil ? results.count : 0;
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    
    
    
    //MARK: Layer delegate
    func mapViewDidLoad(mapView: AGSMapView!) {
        mapView.locationDisplay.startDataSource()
        
        let env = AGSEnvelope(xmin: 10458701.000000, ymin: 542977.875000,
                              xmax: 11986879.000000, ymax: 2498290.000000,
                              spatialReference: AGSSpatialReference.webMercatorSpatialReference());
        mapView.zoomToEnvelope(env, animated: true);
        
        
    }
    
    func initializeMap() {
        
        mapView.layerDelegate = self;
        
        do {
            
            // Get map permisson.
            let resultSet = try NTMapPermissionService.execute();
            
            // Get Street map HD (service id: 2)
            if resultSet.results != nil && resultSet.results.count > 0 {
                let filtered = resultSet.results.filter({ (mp) -> Bool in
                    return mp.serviceId == 2;
                })
                
                if filtered.count > 0 {
                    let mapPermisson = filtered.first;
                    
                    
                    let url = NSURL(string: mapPermisson!.serviceUrl_L);
                    let cred = AGSCredential(token: mapPermisson?.serviceToken_L, referer: referrer);
                    let tiledLayer = AGSTiledMapServiceLayer(URL: url, credential: cred)
                    tiledLayer.delegate = self;
                    
                    mapView.addMapLayer(tiledLayer, withName: mapPermisson!.serviceName);
                }
                
            }
        }
        catch let error as NSError {
            print("error: \(error)");
        }
    }
}

