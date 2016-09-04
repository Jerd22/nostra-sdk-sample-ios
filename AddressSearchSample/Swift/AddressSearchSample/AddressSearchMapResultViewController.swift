//
//  AddressSearchMapResultViewController.swift
//  AddressSearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK
import ArcGIS

class AddressSearchMapResultViewController: UIViewController, AGSLayerDelegate, AGSCalloutDelegate  {

    let referrer = ""
    
    @IBOutlet weak var mapView: AGSMapView!
    var result: NTAddressSearchResult?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeMap();
        
        
    }
    
    //MARK: Callout delegate
    func callout(callout: AGSCallout!, willShowForFeature feature: AGSFeature!, layer: AGSLayer!, mapPoint: AGSPoint!) -> Bool {
        
        callout.title = "\(result!.houseNo), \(result!.soi_L)";
        callout.detail = "\(result!.adminLevel3_L), \(result!.adminLevel2_L), \(result!.adminLevel1_L)"
        
        return true;
    }
    
    
    //MARK: layer delegate
    func layerDidLoad(layer: AGSLayer!) {
        if result != nil {
            let point = AGSPoint(x: result!.lon, y: result!.lat, spatialReference: AGSSpatialReference.wgs84SpatialReference());
            let mappoint = AGSPoint(fromDegreesDecimalMinutesString: point.decimalDegreesStringWithNumDigits(7),
                                    withSpatialReference: AGSSpatialReference.webMercatorSpatialReference());
            
            mapView.zoomToScale(10000, withCenterPoint: mappoint, animated: true);
            
            let graphicLayer = AGSGraphicsLayer();
            mapView.addMapLayer(graphicLayer);
            
            let symbol = AGSPictureMarkerSymbol(imageNamed: "pin_map");
            let graphic = AGSGraphic(geometry: mappoint, symbol: symbol, attributes: nil);
            graphicLayer.addGraphic(graphic);
            mapView.callout.showCalloutAtPoint(mappoint, forFeature: graphic, layer: graphicLayer, animated: true);
            
        }
    }
    
    func initializeMap() {
        
        mapView.callout.delegate = self;
        
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
    

    func layer(layer: AGSLayer!, didFailToLoadWithError error: NSError!) {
        print("\(layer.name) failed to load by reason: \(error.description)");
    }
}
