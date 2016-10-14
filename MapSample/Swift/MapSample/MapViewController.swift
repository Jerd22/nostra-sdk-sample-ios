//
//  ViewController.swift
//  MapSample
//
//  Copyright © 2559 Globtech. All rights reserved.
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
    var selectedBasemap: IndexPath?;
    var selectedLayer: [String]?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.layerDelegate = self;
        
        do {
            
            mapResultSet = try NTMapPermissionService.execute()
            
            if mapResultSet?.results != nil && (mapResultSet?.results.count)! > 0{
                
                let mapResultSetSorted = mapResultSet!.results.sorted(by: { (aService, bService) -> Bool in
                    return aService.sortIndex < bService.sortIndex;
                });
                
                for mapPermission in mapResultSetSorted {

                    if mapPermission.layerType == .basemap || mapPermission.layerType == .imagery {
                        basemaps.append(mapPermission);
                    }
                    else {
                        layers.append(mapPermission);
                    }
                    
                    if mapPermission.serviceId == 2 {
                        self.addLayer(mapPermission);
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            // your function here
                            self.addLayer(mapPermission);
                        }
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
    
    
    func addLayer(_ mapPermission: NTMapPermissionResult) {
        
        var layer: AGSLayer! = nil;
        
        let url = URL(string: mapPermission.serviceUrl_L);
        
        if mapPermission.mapServiceType == .tiledMapService {
            
            var tiledLyr: AGSTiledMapServiceLayer?
            
            if mapPermission.serviceToken_L != nil && mapPermission.serviceToken_L != "" {
                let cred = AGSCredential(token: mapPermission.serviceToken_L, referer: referrer);
                tiledLyr = AGSTiledMapServiceLayer(url: url, credential: cred)
            }
            else {
                tiledLyr = AGSTiledMapServiceLayer(url: url);
                
            }
            
            tiledLyr?.delegate = self;
            layer = tiledLyr;
            
        }
        else if mapPermission.mapServiceType == .dynamicMapService {
            
            var dynamicLyr: AGSDynamicMapServiceLayer?;

            if mapPermission.serviceToken_L != nil && mapPermission.serviceToken_L != "" {
                let cred = AGSCredential(token: mapPermission.serviceToken_L, referer: referrer);
                dynamicLyr = AGSDynamicMapServiceLayer(url: url, credential: cred)
            }
            else {
                dynamicLyr = AGSDynamicMapServiceLayer(url: url);
 
            }
            
            dynamicLyr?.delegate = self;
            
            layer = dynamicLyr;

        }
        else if mapPermission.mapServiceType == .featureService {
            
            var featLayer: AGSFeatureLayer?;
            
            if mapPermission.serviceToken_L != nil && mapPermission.serviceToken_L != "" {
                let cred = AGSCredential(token: mapPermission.serviceToken_L, referer: referrer);
                featLayer = AGSFeatureLayer(url: url, mode: .onDemand, credential: cred);
            }
            else {
                featLayer = AGSFeatureLayer(url: url, mode: .onDemand);
                
            }
            featLayer?.delegate = self;
            
            layer = featLayer;
            
        }
        else if mapPermission.mapServiceType == .webMapService {
            
            let wmsLayer: AGSWMSLayer?;
            
            if mapPermission.serviceToken_L != nil && mapPermission.serviceToken_L != "" {
                let cred = AGSCredential(token: mapPermission.serviceToken_L, referer: referrer);
                wmsLayer = AGSWMSLayer(url: url, credential: cred);
            }
            else {
                wmsLayer = AGSWMSLayer(url: url);
                
            }
            
            wmsLayer?.delegate = self;
            
            layer = wmsLayer;
        }
        else if mapPermission.mapServiceType == .openSteetMap {
            layer = AGSOpenStreetMapLayer();
        }
        

        if layer != nil {
            // layer will be visibled, if service id is 2 (Street map Thailand HD).
            layer.isVisible = mapPermission.serviceId == 2;
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
        btnHide.isHidden = false;
    }
    
    func hideMenu() {
        UIView.beginAnimations(nil, context: nil);
        UIView.setAnimationDuration(0.5);
        tableViewLeading.constant = -260;
        self.view.layoutIfNeeded();
        UIView.commitAnimations();
        btnHide.isHidden = true;
    }
    
    //MARK: UI events
    @IBAction func btnMapLayer_Clicked() {
        showMenu();
    }
    
    
    @IBAction func btnHide_Clicked() {
        hideMenu();
    }
    
    //MARK: Layer delegate
    func mapViewDidLoad(_ mapView: AGSMapView!) {
        
        mapView.locationDisplay.startDataSource()
        
        let env = AGSEnvelope(xmin: 10458701.000000, ymin: 542977.875000,
                              xmax: 11986879.000000, ymax: 2498290.000000,
                              spatialReference: AGSSpatialReference.webMercator());
        mapView.zoom(to: env, animated: true);

    }
    
    func layerDidLoad(_ layer: AGSLayer!) {
        print("\(layer.name) was loaded");
    }
    
    func layer(_ layer: AGSLayer!, didFailToLoadWithError error: Error!) {
        print("\(layer.name) failed to load by reason: \(error)");
        // remove layer, if it fail to load.
        mapView.removeMapLayer(withName: layer.name);
    }
    
    //MARK: Layer management
    func visibleLayer(_ visible: Bool, serviceId: Int) {
        
        if mapResultSet != nil && (mapResultSet?.results.count)! > 0 {
            
            /// Find map
            let filtered = mapResultSet?.results.filter({ (mp) -> Bool in
                return mp.serviceId == serviceId;
            })
            
            if (filtered?.count)! > 0 {
                let mapPermission = filtered?.first;
                
                // Manage layer visible
                let layer = mapView.mapLayer(forName: mapPermission?.serviceName);
                if layer != nil {
                    layer?.isVisible = visible;
                }
                
                // Manamge depend map visible
                if mapPermission?.dependMap != nil && (mapPermission?.dependMap.count)! > 0 {
                    for mapId in (mapPermission?.dependMap)! {
                        
                        self.visibleLayer(visible, serviceId: mapId);
                    }
                }
            }
        }
    }
    
    func findServiceId(_ serviceName: String) -> Int? {
        
        var mapPermission: NTMapPermissionResult! = nil;
        
        if mapResultSet != nil && (mapResultSet?.results.count)! > 0 {
            /// Find map
            let filtered = mapResultSet?.results.filter({ (mp) -> Bool in
                return mp.serviceName == serviceName;
            })
            
            if (filtered?.count)! > 0 {
                mapPermission = filtered?.first;
            }
            
        }
        
        return mapPermission != nil ? mapPermission.serviceId : nil;
        
    }
    
    //MARK: Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {

            if selectedBasemap != nil {
                tableView.deselectRow(at: selectedBasemap!, animated: false);
            }
            selectedBasemap = indexPath
            
        }
        
        let cell = tableView.cellForRow(at: indexPath);
        
        let serviceId = self.findServiceId((cell?.textLabel?.text)!);
        
        if serviceId != nil {
            self.visibleLayer(true, serviceId: serviceId!);
        }
        
        self.hideMenu();
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 1 {
            let cell = tableView.cellForRow(at: indexPath);
            
            let serviceId = self.findServiceId((cell?.textLabel?.text)!);
            
            if serviceId != nil {
                self.visibleLayer(false, serviceId: serviceId!);
            }
        }
        self.hideMenu();
        
    }
    @IBAction func btnLocLocation_Clicked(_ sender: AnyObject) {
        
    }
    
    //MARK: Table view datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!;
        
        var service: NTMapPermissionResult?;
        
        if (indexPath as NSIndexPath).section == 0 && basemaps.count > 0 {
            service = basemaps[indexPath.row];
        }
        else if (indexPath as NSIndexPath).section >= 0 && layers.count > 0 {
            service = layers[indexPath.row];
        }
        
        cell.textLabel?.text = service?.serviceName;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "header")!;
        
        if section == 0 && basemaps.count > 0 {
            cell.textLabel?.text = "Basemap"
        }
        else {
            cell.textLabel?.text = "Layer"
        }
        cell.textLabel?.backgroundColor = UIColor.clear
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
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

