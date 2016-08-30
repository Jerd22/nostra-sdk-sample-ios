//
//  ViewController.swift
//  MapSample
//
//  Created by Itthisak Phueaksri on 4/16/2559 BE.
//  Copyright © 2559 gissoft. All rights reserved.
//

import UIKit
import ArcGIS
import NOSTRASDK

class MapViewController: UIViewController, AGSMapViewLayerDelegate, AGSLayerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mapView: AGSMapView!
    @IBOutlet weak var btnHide: UIButton!
    
    @IBOutlet weak var tableViewLeading: NSLayoutConstraint!

    let referrer = "";
    
    var mapResultSet: NTMapPermissionResultSet?;
    var lods: [AGSLOD]?;
    var basemaps:[NTMapPermissionResult] = [];
    var layers:[NTMapPermissionResult] = []
    var selectedBasemap: NSIndexPath?;
    var selectedLayer: [String]?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.layerDelegate = self;
        
        do {
            
            mapResultSet = try NTMapPermissionService.execute()
            
            if mapResultSet?.results != nil && mapResultSet?.results.count > 0{
                
                let mapResultSetSorted = mapResultSet!.results.sort({ (aService, bService) -> Bool in
                    return aService.sortIndex < bService.sortIndex;
                });
                
                for mapPermission in mapResultSetSorted {

                    if mapPermission.layerType == .Basemap || mapPermission.layerType == .Imagery {
                        basemaps.append(mapPermission);
                    }
                    else {
                        layers.append(mapPermission);
                    }
                    
                    if mapPermission.serviceId == 2 {
                        self.addLayer(mapPermission);
                    }
                    else {
                        dispatch_after(dispatch_time_t(1), dispatch_get_main_queue(), {
                            self.addLayer(mapPermission);
                        })
                    }
                    
                    
                    
                    
                }
                
            }
        }
        catch let error as NSError {
            print("error: \(error)");
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

        
    }
    
    
    func addLayer(mapPermission: NTMapPermissionResult) {
        
        var layer: AGSLayer! = nil;
        
        let url = NSURL(string: mapPermission.serviceUrl_L);
        
        if mapPermission.mapServiceType == .TiledMapService {
            
            var tiledLyr: AGSTiledMapServiceLayer?
            
            if mapPermission.serviceToken_L != nil && mapPermission.serviceToken_L != "" {
                let cred = AGSCredential(token: mapPermission.serviceToken_L, referer: referrer);
                tiledLyr = AGSTiledMapServiceLayer(URL: url, credential: cred)
            }
            else {
                tiledLyr = AGSTiledMapServiceLayer(URL: url);
                
            }
            
            tiledLyr?.delegate = self;
            layer = tiledLyr;
            
        }
        else if mapPermission.mapServiceType == .DynamicMapService {
            
            var dynamicLyr: AGSDynamicMapServiceLayer?;

            if mapPermission.serviceToken_L != nil && mapPermission.serviceToken_L != "" {
                let cred = AGSCredential(token: mapPermission.serviceToken_L, referer: referrer);
                dynamicLyr = AGSDynamicMapServiceLayer(URL: url, credential: cred)
            }
            else {
                dynamicLyr = AGSDynamicMapServiceLayer(URL: url);
 
            }
            
            dynamicLyr?.delegate = self;
            
            layer = dynamicLyr;

        }
        else if mapPermission.mapServiceType == .FeatureService {
            
            var featLayer: AGSFeatureLayer?;
            
            if mapPermission.serviceToken_L != nil && mapPermission.serviceToken_L != "" {
                let cred = AGSCredential(token: mapPermission.serviceToken_L, referer: referrer);
                featLayer = AGSFeatureLayer(URL: url, mode: .OnDemand, credential: cred);
            }
            else {
                featLayer = AGSFeatureLayer(URL: url, mode: .OnDemand);
                
            }
            featLayer?.delegate = self;
            
            layer = featLayer;
            
        }
        else if mapPermission.mapServiceType == .WebMapService {
            
            let wmsLayer: AGSWMSLayer?;
            
            if mapPermission.serviceToken_L != nil && mapPermission.serviceToken_L != "" {
                let cred = AGSCredential(token: mapPermission.serviceToken_L, referer: referrer);
                wmsLayer = AGSWMSLayer(URL: url, credential: cred);
            }
            else {
                wmsLayer = AGSWMSLayer(URL: url);
                
            }
            
            wmsLayer?.delegate = self;
            
            layer = wmsLayer;
        }
        else if mapPermission.mapServiceType == .OpenSteetMap {
            layer = AGSOpenStreetMapLayer();
        }
        

        if layer != nil {
            // layer will be visibled, if service id is 2 (Street map Thailand HD).
            layer.visible = mapPermission.serviceId == 2;
            mapView.addMapLayer(layer, withName: mapPermission.serviceName);
        }
        else {
            print("error to intialize layer: \(mapPermission.serviceName)");
        }
        
        
        
        
    }
    
    
    func showMenu() {
        UIView.beginAnimations(nil, context: nil);
        UIView.setAnimationDuration(0.5);
        tableViewLeading.constant = 0;
        self.view.layoutIfNeeded();
        UIView.commitAnimations();
        btnHide.hidden = false;
    }
    
    func hideMenu() {
        UIView.beginAnimations(nil, context: nil);
        UIView.setAnimationDuration(0.5);
        tableViewLeading.constant = -260;
        self.view.layoutIfNeeded();
        UIView.commitAnimations();
        btnHide.hidden = true;
    }
    
    //MARK: UI events
    @IBAction func btnMapLayer_Clicked() {
        showMenu();
    }
    
    
    @IBAction func btnHide_Clicked() {
        hideMenu();
    }
    
    //MARK: Layer delegate
    func mapViewDidLoad(mapView: AGSMapView!) {
        
        mapView.locationDisplay.startDataSource()
        
        let env = AGSEnvelope(xmin: 10458701.000000, ymin: 542977.875000,
                              xmax: 11986879.000000, ymax: 2498290.000000,
                              spatialReference: AGSSpatialReference.webMercatorSpatialReference());
        mapView.zoomToEnvelope(env, animated: true);

    }
    
    func layerDidLoad(layer: AGSLayer!) {
        print("\(layer.name) was loaded");
    }
    
    func layer(layer: AGSLayer!, didFailToLoadWithError error: NSError!) {
        print("\(layer.name) failed to load by reason: \(error.description)");
        // remove layer, if it fail to load.
        mapView.removeMapLayerWithName(layer.name);
    }
    
    //MARK: Layer management
    func visibleLayer(visible: Bool, serviceId: Int) {
        
        if mapResultSet != nil && mapResultSet?.results.count > 0 {
            
            /// Find map
            let filtered = mapResultSet?.results.filter({ (mp) -> Bool in
                return mp.serviceId == serviceId;
            })
            
            if filtered?.count > 0 {
                let mapPermission = filtered?.first;
                
                // Manage layer visible
                let layer = mapView.mapLayerForName(mapPermission?.serviceName);
                if layer != nil {
                    layer.visible = visible;
                }
                
                // Manamge depend map visible
                if mapPermission?.dependMap != nil && mapPermission?.dependMap.count > 0 {
                    for mapId in (mapPermission?.dependMap)! {
                        
                        self.visibleLayer(visible, serviceId: mapId);
                    }
                }
            }
        }
    }
    
    func findServiceId(serviceName: String) -> Int? {
        
        var mapPermission: NTMapPermissionResult! = nil;
        
        if mapResultSet != nil && mapResultSet?.results.count > 0 {
            /// Find map
            let filtered = mapResultSet?.results.filter({ (mp) -> Bool in
                return mp.serviceName == serviceName;
            })
            
            if filtered?.count > 0 {
                mapPermission = filtered?.first;
            }
            
        }
        
        return mapPermission != nil ? mapPermission.serviceId : nil;
        
    }
    
    //MARK: Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {

            if selectedBasemap != nil {
                tableView.deselectRowAtIndexPath(selectedBasemap!, animated: false);
            }
            selectedBasemap = indexPath
            
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        
        let serviceId = self.findServiceId((cell?.textLabel?.text)!);
        
        if serviceId != nil {
            self.visibleLayer(true, serviceId: serviceId!);
        }
        
        self.hideMenu();
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            let cell = tableView.cellForRowAtIndexPath(indexPath);
            
            let serviceId = self.findServiceId((cell?.textLabel?.text)!);
            
            if serviceId != nil {
                self.visibleLayer(false, serviceId: serviceId!);
            }
        }
        self.hideMenu();
        
    }
    @IBAction func btnLocLocation_Clicked(sender: AnyObject) {
        
    }
    
    //MARK: Table view datasource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!;
        
        var service: NTMapPermissionResult?;
        
        if indexPath.section == 0 && basemaps.count > 0 {
            service = basemaps[indexPath.row];
        }
        else if indexPath.section >= 0 && layers.count > 0 {
            service = layers[indexPath.row];
        }
        
        cell.textLabel?.text = service?.serviceName;
        
        return cell;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("header")!;
        
        if section == 0 && basemaps.count > 0 {
            cell.textLabel?.text = "Basemap"
        }
        else {
            cell.textLabel?.text = "Layer"
        }
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 && basemaps.count > 0 {
            return basemaps.count
        }
        else if section >= 0 && layers.count > 0 {
            return layers.count
        }
        else {
            return 0;
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if basemaps.count > 0 && layers.count > 0 {
            return 2;
        }
        else if basemaps.count > 0 || layers.count > 0 {
            return 1;
        }
        else {
            return 0;
        }
    }
    

}

