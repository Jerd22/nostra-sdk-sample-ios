//
//  ViewController.swift
//  IdentifySample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK
import ArcGIS
class IdentifyViewController: UIViewController, AGSMapViewLayerDelegate, AGSMapViewTouchDelegate, AGSLayerDelegate, AGSCalloutDelegate {

    @IBOutlet weak var mapView: AGSMapView!
    
    let referrer = ""
    
    let graphicLayer = AGSGraphicsLayer();
    var idenResult: NTIdentifyResult?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeMap();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let detailViewController = segue.destinationViewController as! DetailViewController;
            detailViewController.idenResult = idenResult;
            
        }
    }
    
    func initializeMap() {
        
        mapView.layerDelegate = self;
        mapView.touchDelegate = self;
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
                    tiledLayer.renderNativeResolution = true;
                    tiledLayer.delegate = self;
                    
                    mapView.addMapLayer(tiledLayer, withName: mapPermisson!.serviceName);
                }
                
            }
        }
        catch let error as NSError {
            print("error: \(error)");
        }
    }
    
    @IBAction func btnCurrentLocation_Clicked(btn: UIButton) {
        
        btn.selected = !btn.selected;
        mapView.locationDisplay.autoPanMode = btn.selected ? .Default : .Off;
        
    }
    

    //MARK: Touch Delegate
    func mapView(mapView: AGSMapView!, didTapAndHoldAtPoint screen: CGPoint, mapPoint mappoint: AGSPoint!, features: [NSObject : AnyObject]!) {
        
        
        if graphicLayer.graphicsCount > 0 {
            graphicLayer.removeAllGraphics();
        }
        
        let symbol = AGSSimpleMarkerSymbol(color: UIColor.redColor());
        symbol.style = .X;
        symbol.size = CGSizeMake(15, 15);
        
        let graphic = AGSGraphic(geometry: mappoint, symbol: symbol, attributes: nil);
        
        graphicLayer.addGraphic(graphic);
        
    }
    
    //MARK: Callout delegate
    func callout(callout: AGSCallout!, willShowForFeature feature: AGSFeature!, layer: AGSLayer!, mapPoint: AGSPoint!) -> Bool {
        
        var show = false;
        
        do {
            let point = AGSPoint(fromDecimalDegreesString: mapPoint.decimalDegreesStringWithNumDigits(7),
                                 withSpatialReference: AGSSpatialReference.wgs84SpatialReference());

            
            let idenParam = NTIdentifyParameter(lat: point.y, lon: point.x);
            
            idenResult = try NTIdentifyService.execute(idenParam);

            callout.title = idenResult!.name_L;
            callout.detail = "\(idenResult!.adminLevel3_L), \(idenResult!.adminLevel2_L), \(idenResult!.adminLevel1_L)"
            
            
            if idenResult?.nostraId != nil && idenResult?.nostraId != "" {
                callout.accessoryButtonType = .DetailDisclosure
                callout.accessoryButtonHidden = false;
            }
            else {
                callout.accessoryButtonHidden = true;
            }
            
            
            
            
            show = true;
        }
        catch let error as NSError {
            print("error: \(error.description)")
        }
        return show;
    }
    
    
    
    
    func didClickAccessoryButtonForCallout(callout: AGSCallout!) {
        self.performSegueWithIdentifier("detailSegue", sender: nil);
    }
    
    //MARK: Map view and Layer delegate
    func mapViewDidLoad(mapView: AGSMapView!) {
        mapView.locationDisplay.startDataSource()
        
        let env = AGSEnvelope(xmin: 10458701.000000, ymin: 542977.875000,
                              xmax: 11986879.000000, ymax: 2498290.000000,
                              spatialReference: AGSSpatialReference.webMercatorSpatialReference());
        mapView.zoomToEnvelope(env, animated: true);
        
        mapView.addMapLayer(graphicLayer, withName: "GraphicLyaer");
        
    }

    
    func layerDidLoad(layer: AGSLayer!) {
        print("\(layer.name) was loaded");
    }
    
    func layer(layer: AGSLayer!, didFailToLoadWithError error: NSError!) {
        print("\(layer.name) failed to load by reason: \(error.description)");
    }
    
}

