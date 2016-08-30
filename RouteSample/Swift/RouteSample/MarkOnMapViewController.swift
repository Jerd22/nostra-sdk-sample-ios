//
//  MarkOnMapViewController.swift
//  RouteSample
//
//  Created by Itthisak Phueaksri on 5/15/2559 BE.
//  Copyright © 2559 gissoft. All rights reserved.
//

import UIKit
import ArcGIS
import NOSTRASDK

protocol MarkOnMapDelegate {
    func didFinishSelectFromLocation(point: AGSPoint);
    func didFinishSelectToLocation(point: AGSPoint);
}

class MarkOnMapViewController: UIViewController, AGSMapViewLayerDelegate, AGSLayerDelegate {

    let referrer = ""
    
    var delegate:MarkOnMapDelegate?;
    
    @IBOutlet weak var mapView: AGSMapView!
    
    
    
    var isFromLocation = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initializeMap();
        
        
    }
    
    
    @IBAction func btnOk_Clicked(sender: AnyObject) {
        
        if isFromLocation {
            delegate?.didFinishSelectFromLocation(mapView.mapAnchor);
            
        } else {
            delegate?.didFinishSelectToLocation(mapView.mapAnchor);
        }
        
        self.navigationController?.popViewControllerAnimated(true);
        
    }

    @IBAction func btnCancel_Clicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func initializeMap() {
        
        do {
            mapView.layerDelegate = self;
            
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
    
    //MARK: Map view and Layer delegate
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
    }
    
}
