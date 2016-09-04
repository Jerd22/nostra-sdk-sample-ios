//
//  ViewController.swift
//  ServiceAreaSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import ArcGIS
import NOSTRASDK

class ServiceAreaViewController: UIViewController, AGSMapViewLayerDelegate, AGSMapViewTouchDelegate, AGSCalloutDelegate, AGSLayerDelegate {
    
    let referrer = ""
    
    @IBOutlet weak var mapView: AGSMapView!
    
    let graphicLayer = AGSGraphicsLayer();
    let serviceAreaLayer = AGSGraphicsLayer();
    
    let redAreaColor = UIColor(red: 255.0/255.0, green: 0, blue: 0, alpha: 0.5);
    let yellowAreaColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0, alpha: 0.5);
    let greenAreaColor = UIColor(red: 0, green: 255.0/255.0, blue: 0, alpha: 0.5);
    var idenResult: NTIdentifyResult?;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializeMap();
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnCurrentLocation_Clicked(btn: UIButton) {
        
        btn.selected = !btn.selected;
        mapView.locationDisplay.autoPanMode = btn.selected ? .Default : .Off;
        
    }
    
    
    //MARK: Touch Delegate
    func mapView(mapView: AGSMapView!, didClickAtPoint screen: CGPoint, mapPoint mappoint: AGSPoint!, features: [NSObject : AnyObject]!) {
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        

        alertController.addAction(UIAlertAction(title: "Pin Location", style: .Default) {
            (alert) in
            

            self.graphicLayer.removeAllGraphics();
            self.serviceAreaLayer.removeAllGraphics();
            
            let graphic = AGSGraphic(geometry: mappoint,
                                     symbol: AGSPictureMarkerSymbol(imageNamed: "pin_map"),
                                     attributes: nil);
            
            self.graphicLayer.addGraphic(graphic);
            
            let point = AGSPoint(fromDecimalDegreesString: mappoint.decimalDegreesStringWithNumDigits(7),
                withSpatialReference: AGSSpatialReference.wgs84SpatialReference());
            
            
            
            let param = NTServiceAreaParameter(facilities: [NTLocation(name: "facility", lat: point.y, lon: point.x)], breaks: [1, 3, 5])
            
            do {
                let result = try NTServiceAreaService.execute(param)
                
                var area: NTServiceAreaResult! = nil;
                
                if  result.results.count == 3 {
                    
                    area = result.results[2];
                    var polygon = AGSPolygon(JSON: area.getShape(), spatialReference: AGSSpatialReference.wgs84SpatialReference())
                    var geometry = AGSGeometryEngine.defaultGeometryEngine().projectGeometry(polygon, toSpatialReference: AGSSpatialReference.webMercatorSpatialReference())
                    var symbol = AGSSimpleFillSymbol(color: self.redAreaColor, outlineColor: self.redAreaColor);
                    var graphic = AGSGraphic(geometry: geometry, symbol: symbol, attributes: nil);
                    
                    self.serviceAreaLayer.addGraphic(graphic);
                    
                    area = result.results[1];
                    polygon = AGSPolygon(JSON: area.getShape(), spatialReference: AGSSpatialReference.wgs84SpatialReference())
                    geometry = AGSGeometryEngine.defaultGeometryEngine().projectGeometry(polygon, toSpatialReference: AGSSpatialReference.webMercatorSpatialReference())
                    symbol = AGSSimpleFillSymbol(color: self.yellowAreaColor, outlineColor: self.yellowAreaColor);
                    graphic = AGSGraphic(geometry: geometry, symbol: symbol, attributes: nil);
                    
                    self.serviceAreaLayer.addGraphic(graphic);
                    
                    area = result.results[0];
                    polygon = AGSPolygon(JSON: area.getShape(), spatialReference: AGSSpatialReference.wgs84SpatialReference())
                    geometry = AGSGeometryEngine.defaultGeometryEngine().projectGeometry(polygon, toSpatialReference: AGSSpatialReference.webMercatorSpatialReference())
                    symbol = AGSSimpleFillSymbol(color: self.greenAreaColor, outlineColor: self.greenAreaColor);
                    graphic = AGSGraphic(geometry: geometry, symbol: symbol, attributes: nil);
                    
                    self.serviceAreaLayer.addGraphic(graphic);
                    
                    mapView.zoomToGeometry(geometry, withPadding: 10, animated: true);
                }
                
                
                
                
            }
            catch let error as NSError {
                print("error: \(error.description)");
            }
            
            
            });
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil);

    }
    
    
    //MARK: Layer delegate
    func mapViewDidLoad(mapView: AGSMapView!) {
        mapView.locationDisplay.startDataSource()
        
        let env = AGSEnvelope(xmin: 10458701.000000, ymin: 542977.875000,
                              xmax: 11986879.000000, ymax: 2498290.000000,
                              spatialReference: AGSSpatialReference.webMercatorSpatialReference());
        mapView.zoomToEnvelope(env, animated: true);
        
        mapView.addMapLayer(serviceAreaLayer);
        mapView.addMapLayer(graphicLayer);
        
        
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
