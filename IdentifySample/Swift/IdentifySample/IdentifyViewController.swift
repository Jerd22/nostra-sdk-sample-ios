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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailViewController = segue.destination as! DetailViewController;
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
                    
                    
                    let url = URL(string: mapPermisson!.serviceUrl_L);
                    let cred = AGSCredential(token: mapPermisson?.serviceToken_L, referer: referrer);
                    let tiledLayer = AGSTiledMapServiceLayer(url: url, credential: cred)
                    tiledLayer?.renderNativeResolution = true;
                    tiledLayer?.delegate = self;
                    
                    mapView.addMapLayer(tiledLayer, withName: mapPermisson!.serviceName);
                }
                
            }
        }
        catch let error as NSError {
            print("error: \(error)");
        }
    }
    
    @IBAction func btnCurrentLocation_Clicked(_ btn: UIButton) {
        
        btn.isSelected = !btn.isSelected;
        mapView.locationDisplay.autoPanMode = btn.isSelected ? .default : .off;
        
    }
    

    //MARK: Touch Delegate
    func mapView(_ mapView: AGSMapView!, didTapAndHoldAt screen: CGPoint, mapPoint mappoint: AGSPoint!, features: [AnyHashable: Any]!) {
        
        
        if graphicLayer.graphicsCount > 0 {
            graphicLayer.removeAllGraphics();
        }
        
        let symbol = AGSSimpleMarkerSymbol(color: UIColor.red);
        symbol?.style = .X;
        symbol?.size = CGSize(width: 15, height: 15);
        
        let graphic = AGSGraphic(geometry: mappoint, symbol: symbol, attributes: nil);
        
        graphicLayer.addGraphic(graphic);
        
    }
    
    //MARK: Callout delegate
    func callout(_ callout: AGSCallout!, willShowFor feature: AGSFeature!, layer: AGSLayer!, mapPoint: AGSPoint!) -> Bool {
        
        var show = false;
        
        do {
            let point = AGSPoint(fromDecimalDegreesString: mapPoint.decimalDegreesString(withNumDigits: 7),
                                 with: AGSSpatialReference.wgs84());

            
            let idenParam = NTIdentifyParameter(lat: (point?.y)!, lon: (point?.x)!);
            
            idenResult = try NTIdentifyService.execute(idenParam);

            callout.title = idenResult!.name_L;
            callout.detail = "\(idenResult!.adminLevel3_L), \(idenResult!.adminLevel2_L), \(idenResult!.adminLevel1_L)"
            
            
            if idenResult?.nostraId != nil && idenResult?.nostraId != "" {
                callout.accessoryButtonType = .detailDisclosure
                callout.isAccessoryButtonHidden = false;
            }
            else {
                callout.isAccessoryButtonHidden = true;
            }
            
            
            
            
            show = true;
        }
        catch let error as NSError {
            print("error: \(error.description)")
        }
        return show;
    }
    
    
    
    
    func didClickAccessoryButton(for callout: AGSCallout!) {
        self.performSegue(withIdentifier: "detailSegue", sender: nil);
    }
    
    //MARK: Map view and Layer delegate
    func mapViewDidLoad(_ mapView: AGSMapView!) {
        mapView.locationDisplay.startDataSource()
        
        let env = AGSEnvelope(xmin: 10458701.000000, ymin: 542977.875000,
                              xmax: 11986879.000000, ymax: 2498290.000000,
                              spatialReference: AGSSpatialReference.webMercator());
        mapView.zoom(to: env, animated: true);
        
        mapView.addMapLayer(graphicLayer, withName: "GraphicLyaer");
        
    }

    
    func layerDidLoad(_ layer: AGSLayer!) {
        print("\(layer.name) was loaded");
    }
    
    func layer(_ layer: AGSLayer!, didFailToLoadWithError error: Error!) {
        print("\(layer.name) failed to load by reason: \(error.localizedDescription)");
    }
    
}

