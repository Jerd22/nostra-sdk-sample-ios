//
//  ViewController.swift
//  RouteSample
//
//  Created by Itthisak Phueaksri on 4/17/2559 BE.
//  Copyright © 2559 gissoft. All rights reserved.
//

import UIKit
import ArcGIS
import NOSTRASDK

class RouteViewController: UIViewController, AGSMapViewLayerDelegate, AGSLayerDelegate, MarkOnMapDelegate {

    let referrer = "th.co.gissoft.nostrasdk"
    
    @IBOutlet weak var mapView: AGSMapView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var lblResult: UILabel!
    
    @IBOutlet weak var btnFromLocation: UIButton!
    @IBOutlet weak var btnToLocation: UIButton!
    
    var fromLocation: NTLocation! = nil;
    var toLocation: NTLocation! = nil;
    
    var vehicle: NTTravelMode = .Car;
    
    var result: NTRouteResult?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeMap();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnVehicle_Clicked(sender: AnyObject) {
        let btn = sender as? UIButton;
        let alertController = UIAlertController(title: "Vehicle", message: nil, preferredStyle: .ActionSheet);
        alertController.addAction(UIAlertAction(title: "Car", style: .Default, handler: { (action) in
            self.vehicle = .Car;
            btn?.setTitle("Car", forState: .Normal);
        }));
        alertController.addAction(UIAlertAction(title: "Motocycle", style: .Default, handler: { (action) in
            self.vehicle = .MotorCycle;
            btn?.setTitle("Motocycle", forState: .Normal);
        }));
        alertController.addAction(UIAlertAction(title: "Bike", style: .Default, handler: { (action) in
            self.vehicle = .Bicycle;
            btn?.setTitle("Bike", forState: .Normal);
        }));
        alertController.addAction(UIAlertAction(title: "Walk", style: .Default, handler: { (action) in
            self.vehicle = .Walk;
            btn?.setTitle("Walk", forState: .Normal);
        }));
        
        self .presentViewController(alertController, animated: true, completion: nil);
    }
    
    
    @IBAction func btnRoute_Clicked(sender: AnyObject) {
        if toLocation != nil && fromLocation != nil {
            let param = NTRouteParameter(stops: [fromLocation, toLocation]);
            param.travelMode = vehicle;
            
            do {
                result = try NTRouteService.execute(param)
                
                let polyline = AGSPolyline(JSON: result!.getShape(), spatialReference: AGSSpatialReference.wgs84SpatialReference());
                let geometry = AGSGeometryEngine.defaultGeometryEngine().projectGeometry(polyline,
                                                                                         toSpatialReference: AGSSpatialReference.webMercatorSpatialReference());
                
                
                
                let graphicLayer = AGSGraphicsLayer();
                mapView.addMapLayer(graphicLayer);
                
                let color = UIColor(red: 63.0/255.0, green: 81.0/255.0, blue: 181.0/255.0, alpha: 1.0);
                let symbol = AGSSimpleLineSymbol(color: color, width: 3.0);
                
                let graphic = AGSGraphic(geometry: geometry, symbol: symbol, attributes: nil);

                graphicLayer.addGraphic(graphic);
                
                lblResult.text = String.init(format: "%.1f min (%.1f Km.)", result!.totalTime, result!.totalLength / 1000);
                resultView.hidden = false;
                
                mapView.zoomToGeometry(graphic?.geometry, withPadding: 50, animated: true);
                
            }
            catch let error as NSError {
                print("error \(error.description)");
            }
            
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromLocationSegue" || segue.identifier == "toLocationSegue" {
            let markOnMapViewController = segue.destinationViewController as? MarkOnMapViewController;
            markOnMapViewController?.delegate = self;
            markOnMapViewController?.isFromLocation = segue.identifier == "fromLocationSegue";
        }
        else if segue.identifier == "routeDetailSegue" {
            let detailViewController = segue.destinationViewController as? RouteDetailViewController;
            detailViewController?.directions = result!.directions;
        }
    }
    

    func didFinishSelectToLocation(point: AGSPoint) {
        let llPoint = AGSPoint(fromDecimalDegreesString: point.decimalDegreesStringWithNumDigits(7),
                               withSpatialReference: AGSSpatialReference.wgs84SpatialReference());
        
        toLocation = NTLocation(name: "location 2", lat: llPoint.y, lon: llPoint.x);
        btnToLocation.setTitleColor(UIColor.blackColor(), forState: .Normal);
        btnToLocation.setTitle(toLocation.name, forState: .Normal);
        
    }
    
    func didFinishSelectFromLocation(point: AGSPoint) {
        let llPoint = AGSPoint(fromDecimalDegreesString: point.decimalDegreesStringWithNumDigits(7),
                               withSpatialReference: AGSSpatialReference.wgs84SpatialReference());
        
        fromLocation = NTLocation(name: "location1", lat: llPoint.y, lon: llPoint.x);
        btnFromLocation.setTitleColor(UIColor.blackColor(), forState: .Normal);
        btnFromLocation.setTitle(fromLocation.name, forState: .Normal);
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

