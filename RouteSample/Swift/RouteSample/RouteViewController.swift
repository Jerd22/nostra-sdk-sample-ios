//
//  ViewController.swift
//  RouteSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import ArcGIS
import NOSTRASDK

class RouteViewController: UIViewController, AGSMapViewLayerDelegate, AGSLayerDelegate, MarkOnMapDelegate {

    let referrer = ""
    
    @IBOutlet weak var mapView: AGSMapView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var lblResult: UILabel!
    
    @IBOutlet weak var btnFromLocation: UIButton!
    @IBOutlet weak var btnToLocation: UIButton!
    
    var fromLocation: NTLocation! = nil;
    var toLocation: NTLocation! = nil;
    
    var vehicle: NTTravelMode = .car;
    
    var result: NTRouteResult?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeMap();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnVehicle_Clicked(_ sender: AnyObject) {
        let btn = sender as? UIButton;
        let alertController = UIAlertController(title: "Vehicle", message: nil, preferredStyle: .actionSheet);
        alertController.addAction(UIAlertAction(title: "Car", style: .default, handler: { (action) in
            self.vehicle = .car;
            btn?.setTitle("Car", for: UIControlState());
        }));
        alertController.addAction(UIAlertAction(title: "Motocycle", style: .default, handler: { (action) in
            self.vehicle = .motorCycle;
            btn?.setTitle("Motocycle", for: UIControlState());
        }));
        alertController.addAction(UIAlertAction(title: "Bike", style: .default, handler: { (action) in
            self.vehicle = .bicycle;
            btn?.setTitle("Bike", for: UIControlState());
        }));
        alertController.addAction(UIAlertAction(title: "Walk", style: .default, handler: { (action) in
            self.vehicle = .walk;
            btn?.setTitle("Walk", for: UIControlState());
        }));
        
        self .present(alertController, animated: true, completion: nil);
    }
    
    
    @IBAction func btnRoute_Clicked(_ sender: AnyObject) {
        if toLocation != nil && fromLocation != nil {
            let param = NTRouteParameter(stops: [fromLocation, toLocation]);
            param.travelMode = vehicle;
            
            do {
                result = try NTRouteService.execute(param)
                
                let polyline = AGSPolyline(json: result!.getShape(), spatialReference: AGSSpatialReference.wgs84());
                let geometry = AGSGeometryEngine.default().projectGeometry(polyline,
                                                                                         to: AGSSpatialReference.webMercator());
                
                
                
                let graphicLayer = AGSGraphicsLayer();
                mapView.addMapLayer(graphicLayer);
                
                let color = UIColor(red: 63.0/255.0, green: 81.0/255.0, blue: 181.0/255.0, alpha: 1.0);
                let symbol = AGSSimpleLineSymbol(color: color, width: 3.0);
                
                let graphic = AGSGraphic(geometry: geometry, symbol: symbol, attributes: nil);

                graphicLayer.addGraphic(graphic);
                
                lblResult.text = String.init(format: "%.1f min (%.1f Km.)", result!.totalTime, result!.totalLength / 1000);
                resultView.isHidden = false;
                
                mapView.zoom(to: graphic?.geometry, withPadding: 50, animated: true);
                
            }
            catch let error as NSError {
                print("error \(error.description)");
            }
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromLocationSegue" || segue.identifier == "toLocationSegue" {
            let markOnMapViewController = segue.destination as? MarkOnMapViewController;
            markOnMapViewController?.delegate = self;
            markOnMapViewController?.isFromLocation = segue.identifier == "fromLocationSegue";
        }
        else if segue.identifier == "routeDetailSegue" {
            let detailViewController = segue.destination as? RouteDetailViewController;
            detailViewController?.directions = result!.directions;
        }
    }
    

    func didFinishSelectToLocation(_ point: AGSPoint) {
        let llPoint = AGSPoint(fromDecimalDegreesString: point.decimalDegreesString(withNumDigits: 7),
                               with: AGSSpatialReference.wgs84());
        
        toLocation = NTLocation(name: "location 2", lat: (llPoint?.y)!, lon: (llPoint?.x)!);
        btnToLocation.setTitleColor(UIColor.black, for: UIControlState());
        btnToLocation.setTitle(toLocation.name, for: .normal);
        
    }
    
    func didFinishSelectFromLocation(_ point: AGSPoint) {
        let llPoint = AGSPoint(fromDecimalDegreesString: point.decimalDegreesString(withNumDigits: 7),
                               with: AGSSpatialReference.wgs84());
        
        fromLocation = NTLocation(name: "location1", lat: (llPoint?.y)!, lon: (llPoint?.x)!);
        btnFromLocation.setTitleColor(UIColor.black, for: UIControlState());
        btnFromLocation.setTitle(fromLocation.name, for: .normal);
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
                    
                    
                    let url = URL(string: mapPermisson!.serviceUrl_L);
                    let cred = AGSCredential(token: mapPermisson?.serviceToken_L, referer: referrer);
                    let tiledLayer = AGSTiledMapServiceLayer(url: url, credential: cred)
                    tiledLayer?.delegate = self;
                    
                    mapView.addMapLayer(tiledLayer, withName: mapPermisson!.serviceName);
                }
                
            }
        }
        catch let error as NSError {
            print("error: \(error)");
        }
    }
    
    //MARK: Map view and Layer delegate
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
    }
    

}

