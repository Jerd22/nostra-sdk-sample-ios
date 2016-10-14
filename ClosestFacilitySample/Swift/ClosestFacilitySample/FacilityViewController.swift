//
//  ViewController.swift
//  ClosestFacilitySample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import ArcGIS
import NOSTRASDK
class FacilityViewController: UIViewController, AGSMapViewLayerDelegate, AGSMapViewTouchDelegate, AGSCalloutDelegate, AGSLayerDelegate {
    
    @IBOutlet weak var mapView: AGSMapView!
    
    let referrer = ""
    
    let graphicLayer = AGSGraphicsLayer();
    let facilityLayer = AGSGraphicsLayer();

    var idenResult: NTIdentifyResult?;
    
    let facility1 = NTLocation(name: "MBK", lat: 13.744651781616076, lon: 100.52989481845307)
    let facility2 = NTLocation(name: "SiamDis", lat: 13.746598089591219, lon: 100.53145034771327)
    let facility3 = NTLocation(name: "SiamCenter", lat: 13.746321783330115, lon: 100.53279034433699)
    let facility4 = NTLocation(name: "SiamParagon", lat: 13.746155248206387, lon: 100.53481456769379)
    
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
            
            self.facilityLayer.removeAllGraphics();
            
            let graphic = AGSGraphic(geometry: mappoint,
                symbol: AGSPictureMarkerSymbol(imageNamed: "pin_map"),
                attributes: nil);
            
            self.facilityLayer.addGraphic(graphic);
            
            let point = AGSPoint(fromDecimalDegreesString: mappoint.decimalDegreesString(withNumDigits: 7),
                with: AGSSpatialReference.wgs84());
            
            let incident = [NTLocation(name: "Incident", lat: (point?.y)!, lon: (point?.x)!)];
            let facilities = [self.facility1, self.facility2, self.facility3, self.facility4];
            let param = NTClosestFacilityParameter(facilities: facilities, incident: incident)

            
            do {
                let result = try NTClosestFacilityService.execute(param)
                
                let lineSymbol = AGSSimpleLineSymbol(color: UIColor.lightGray,width: 4);
                
                for facility in result.closestFacilities! {
                    
                    let line = AGSPolyline(json: facility.getShape(), spatialReference: AGSSpatialReference.wgs84())
                    let geometry = AGSGeometryEngine.default().projectGeometry(line, to: AGSSpatialReference.webMercator())
                    let graphic = AGSGraphic(geometry: geometry, symbol: lineSymbol, attributes: nil);
                    self.facilityLayer.addGraphic(graphic);
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
        
        mapView.addMapLayer(facilityLayer);
        mapView.addMapLayer(graphicLayer);
        
        //add facility
        let facilityPoint1 = AGSPoint(x: facility1.lon, y: facility1.lat,
                                      spatialReference: AGSSpatialReference.wgs84());
        let facilityPoint2 = AGSPoint(x: facility2.lon, y: facility2.lat,
                                      spatialReference: AGSSpatialReference.wgs84());
        let facilityPoint3 = AGSPoint(x: facility3.lon, y: facility3.lat,
                                      spatialReference: AGSSpatialReference.wgs84());
        let facilityPoint4 = AGSPoint(x: facility4.lon, y: facility4.lat,
                                      spatialReference: AGSSpatialReference.wgs84());

        let fMappoint1 = AGSPoint(fromDecimalDegreesString: facilityPoint1?.decimalDegreesString(withNumDigits: 7),
                                  with: AGSSpatialReference.webMercator())
        let fMappoint2 = AGSPoint(fromDecimalDegreesString: facilityPoint2?.decimalDegreesString(withNumDigits: 7),
                                  with: AGSSpatialReference.webMercator())
        let fMappoint3 = AGSPoint(fromDecimalDegreesString: facilityPoint3?.decimalDegreesString(withNumDigits: 7),
                                  with: AGSSpatialReference.webMercator())
        let fMappoint4 = AGSPoint(fromDecimalDegreesString: facilityPoint4?.decimalDegreesString(withNumDigits: 7),
                                  with: AGSSpatialReference.webMercator())
        
        let compSymbol = AGSCompositeSymbol();
        let circleSymbol = AGSSimpleMarkerSymbol(color: UIColor.white);
        circleSymbol?.outline = AGSSimpleLineSymbol(color: UIColor.black, width: 2.0);
        circleSymbol?.size = CGSize(width: 30, height: 30);
        let textSymbol  = AGSTextSymbol(text: "1", color: UIColor.black);
        
        compSymbol.addSymbols([circleSymbol, textSymbol]);
        
        let fGraphic1 = AGSGraphic(geometry: fMappoint1, symbol: compSymbol.copy() as! AGSSymbol, attributes: nil);
        textSymbol?.text = "2";
        let fGraphic2 = AGSGraphic(geometry: fMappoint2, symbol: compSymbol.copy() as! AGSSymbol, attributes: nil);
        textSymbol?.text = "3";
        let fGraphic3 = AGSGraphic(geometry: fMappoint3, symbol: compSymbol.copy() as! AGSSymbol, attributes: nil);
        textSymbol?.text = "4";
        let fGraphic4 = AGSGraphic(geometry: fMappoint4, symbol: compSymbol, attributes: nil);
        
        graphicLayer.addGraphics([fGraphic1, fGraphic2, fGraphic3, fGraphic4]);
        
        //find envelope
        let envGeo = AGSGeometryEngine.default().unionGeometries([fMappoint1,fMappoint2,fMappoint3,fMappoint4]);
        mapView.zoom(to: envGeo, withPadding: 100, animated: true);
        
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
