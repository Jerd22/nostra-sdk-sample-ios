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
    
    
    @IBAction func btnCurrentLocation_Clicked(_ btn: UIButton) {
        
        btn.isSelected = !btn.isSelected;
        mapView.locationDisplay.autoPanMode = btn.isSelected ? .default : .off;
        
    }
    
    
    //MARK: Touch Delegate
    func mapView(_ mapView: AGSMapView!, didClickAt screen: CGPoint, mapPoint mappoint: AGSPoint!, features: [AnyHashable: Any]!) {
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        

        alertController.addAction(UIAlertAction(title: "Pin Location", style: .default) {
            (alert) in
            

            self.graphicLayer.removeAllGraphics();
            self.serviceAreaLayer.removeAllGraphics();
            
            let graphic = AGSGraphic(geometry: mappoint,
                                     symbol: AGSPictureMarkerSymbol(imageNamed: "pin_map"),
                                     attributes: nil);
            
            self.graphicLayer.addGraphic(graphic);
            
            let point = AGSPoint(fromDecimalDegreesString: mappoint.decimalDegreesString(withNumDigits: 7),
                with: AGSSpatialReference.wgs84());
            
            
            
            let param = NTServiceAreaParameter(facilities: [NTLocation(name: "facility", lat: (point?.y)!, lon: (point?.x)!)], breaks: [1, 3, 5])
            
            do {
                let result = try NTServiceAreaService.execute(param)
                
                var area: NTServiceAreaResult! = nil;
                
                if  result.results.count == 3 {
                    
                    area = result.results[2];
                    var polygon = AGSPolygon(json: area.getShape(), spatialReference: AGSSpatialReference.wgs84())
                    var geometry = AGSGeometryEngine.default().projectGeometry(polygon, to: AGSSpatialReference.webMercator())
                    var symbol = AGSSimpleFillSymbol(color: self.redAreaColor, outlineColor: self.redAreaColor);
                    var graphic = AGSGraphic(geometry: geometry, symbol: symbol, attributes: nil);
                    
                    self.serviceAreaLayer.addGraphic(graphic);
                    
                    area = result.results[1];
                    polygon = AGSPolygon(json: area.getShape(), spatialReference: AGSSpatialReference.wgs84())
                    geometry = AGSGeometryEngine.default().projectGeometry(polygon, to: AGSSpatialReference.webMercator())
                    symbol = AGSSimpleFillSymbol(color: self.yellowAreaColor, outlineColor: self.yellowAreaColor);
                    graphic = AGSGraphic(geometry: geometry, symbol: symbol, attributes: nil);
                    
                    self.serviceAreaLayer.addGraphic(graphic);
                    
                    area = result.results[0];
                    polygon = AGSPolygon(json: area.getShape(), spatialReference: AGSSpatialReference.wgs84())
                    geometry = AGSGeometryEngine.default().projectGeometry(polygon, to: AGSSpatialReference.webMercator())
                    symbol = AGSSimpleFillSymbol(color: self.greenAreaColor, outlineColor: self.greenAreaColor);
                    graphic = AGSGraphic(geometry: geometry, symbol: symbol, attributes: nil);
                    
                    self.serviceAreaLayer.addGraphic(graphic);
                    
                    mapView.zoom(to: geometry, withPadding: 10, animated: true);
                }
                
                
                
                
            }
            catch let error as NSError {
                print("error: \(error.description)");
            }
            
            
            });
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil);

    }
    
    
    //MARK: Layer delegate
    func mapViewDidLoad(_ mapView: AGSMapView!) {
        mapView.locationDisplay.startDataSource()
        
        let env = AGSEnvelope(xmin: 10458701.000000, ymin: 542977.875000,
                              xmax: 11986879.000000, ymax: 2498290.000000,
                              spatialReference: AGSSpatialReference.webMercator());
        mapView.zoom(to: env, animated: true);
        
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
    
}
