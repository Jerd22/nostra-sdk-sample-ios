//
//  ViewController.swift
//  MultiModalSample
//
//  Created by Itthisak Phueaksri on 5/15/2559 BE.
//  Copyright © 2559 gissoft. All rights reserved.
//

import UIKit
import ArcGIS
import NOSTRASDK

class MultiModalMainViewController: UIViewController, MarkOnMapDelegate, TravelByDelegate, AGSMapViewLayerDelegate, AGSLayerDelegate {

    let referrer = ""
    
    @IBOutlet weak var mapView: AGSMapView!
    
    var graphicLayer: AGSGraphicsLayer! = nil;
    
    @IBOutlet weak var btnFromLocation: UIButton!
    @IBOutlet weak var btnToLocation: UIButton!
    
    var toLocation: NTLocation! = nil;
    var fromLocation: NTLocation! = nil;
    var travels: [NTMultiModalTransportMode]! = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializeMap();
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is TravelByViewController {
            let travelViewController = segue.destinationViewController as! TravelByViewController;
            travelViewController.delegate = self;
        }
        else if segue.destinationViewController is MarkOnMapViewController {
            let markOnMapViewController = segue.destinationViewController as! MarkOnMapViewController;
            let btn = sender as! UIButton;
            markOnMapViewController.delegate = self;
            markOnMapViewController.isFromLocation = btn.tag == 0;
        }
    }
    
    @IBAction func btnCalculate_Clicked(sender: AnyObject) {
        
        
        if self.travels.count > 0 {
            self.CallMultiModalRoute([fromLocation, toLocation], mode: self.travels)
        }
        
        
    }
    
    func CallMultiModalRoute(stops: [NTLocation], mode: [NTMultiModalTransportMode]) {
        
        do {
            
            let param = NTMultiModalTransportParamter(stops: stops, travelMode: mode);
            let result = try NTMultiModalTransportService.execute(param)
            var geometry: [AGSGeometry]! = [];
            if result.minute != nil {
                
                for direction in result.minute.directions! {
                    
                    let polyline = AGSPolyline(JSON: direction.getShape(),
                                               spatialReference: AGSSpatialReference.wgs84SpatialReference());
                    let geo = AGSGeometryEngine.defaultGeometryEngine().projectGeometry(polyline, toSpatialReference: AGSSpatialReference.webMercatorSpatialReference())
                    
                    geometry.append(geo);
                    
                    let symbol = AGSSimpleLineSymbol(color: UIColor(red: direction.type == "Walk" ? 0.0 : 1.0, green: 0, blue: direction.type == "Walk" ? 1.0 : 0.0, alpha: direction.type == "Walk" ? 1.0 : 0.5));
                    symbol.style = direction.type == "Walk" ? .Dot : .Solid;
                    symbol.width = 10.0
                    let graphic = AGSGraphic(geometry: geo, symbol: symbol, attributes: nil);
                    
                    graphicLayer.addGraphic(graphic)
                    
                }
                
                let uGeo = AGSGeometryEngine.defaultGeometryEngine().unionGeometries(geometry);
                
                mapView.zoomToGeometry(uGeo, withPadding: 10, animated: true);
                
                
            }
            
        }
        catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        

    }
    
    func didFinishSelectTravelMode(travels: [NTMultiModalTransportMode]) {
        self.travels = travels;
    }
    
    func didFinishSelectToLocation(point: AGSPoint) {
        toLocation = NTLocation(name: "location 2", lat: point.y, lon: point.x)
        btnToLocation.setTitle("location 2", forState: .Normal);
        btnToLocation.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    func didFinishSelectFromLocation(point: AGSPoint) {
        fromLocation = NTLocation(name: "location 1", lat: point.y, lon: point.x)
        btnFromLocation.setTitle("location 1", forState: .Normal);
        btnFromLocation.setTitleColor(UIColor.blackColor(), forState: .Normal)
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
    
    
    //MARK: Map view and Layer delegate
    func mapViewDidLoad(mapView: AGSMapView!) {
        mapView.locationDisplay.startDataSource()
        
        let env = AGSEnvelope(xmin: 10458701.000000, ymin: 542977.875000,
                              xmax: 11986879.000000, ymax: 2498290.000000,
                              spatialReference: AGSSpatialReference.webMercatorSpatialReference());
        mapView.zoomToEnvelope(env, animated: true);
        
        
        graphicLayer = AGSGraphicsLayer(spatialReference: mapView.spatialReference);
        
        mapView.addMapLayer(graphicLayer, withName: "GraphicLyaer");
        
        
        
    }
    
    
    func layerDidLoad(layer: AGSLayer!) {
        print("\(layer.name) was loaded");
    }
    
    func layer(layer: AGSLayer!, didFailToLoadWithError error: NSError!) {
        print("\(layer.name) failed to load by reason: \(error.description)");
    }
}

