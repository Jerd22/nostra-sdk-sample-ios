//
//  ViewController.swift
//  WeatherForcastSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK
import ArcGIS

class WeatherViewController: UIViewController, AGSMapViewLayerDelegate, AGSMapViewTouchDelegate, AGSCalloutDelegate, AGSLayerDelegate {
    
    let referrer = ""
    
    @IBOutlet weak var mapView: AGSMapView!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblAvgTemp: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!

    let graphicLayer = AGSGraphicsLayer();
    var weatherResult: NTWeatherResult?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initializeMap();
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Touch Delegate
    func mapView(_ mapView: AGSMapView!, didTapAndHoldAt screen: CGPoint, mapPoint mappoint: AGSPoint!, features: [AnyHashable: Any]!) {
        
        
        if graphicLayer.graphicsCount > 0 {
            graphicLayer.removeAllGraphics();
        }
        
        let symbol = AGSPictureMarkerSymbol(imageNamed: "pin_map");
        
        let graphic = AGSGraphic(geometry: mappoint, symbol: symbol, attributes: nil);
        
        graphicLayer.addGraphic(graphic);
        
        
        mapView.callout.show(at: mappoint, for: graphic, layer: graphicLayer, animated: true);
    }
    
    //MARK: Callout delegate
    func callout(_ callout: AGSCallout!, willShowFor feature: AGSFeature!, layer: AGSLayer!, mapPoint: AGSPoint!) -> Bool {
        
        do {
            let point = AGSPoint(fromDecimalDegreesString: mapPoint.decimalDegreesString(withNumDigits: 7),
                                 with: AGSSpatialReference.wgs84());
            

            let param = NTWeatherParameter(lat: point!.y, lon: point!.x, frequency: .daily);
            
            weatherResult = try NTWeatherService.execute(param);
            
            if (weatherResult?.weather?.count)! > 0 {
                
                do {
                    let weather = weatherResult?.weather?.first;
                    let image = try UIImage(data: Data(contentsOf: URL(string: weather!.icon!)!));
                    callout.image = image;
                    callout.isAccessoryButtonHidden = true;
                    
                    let formatter = DateFormatter();
                    formatter.dateFormat = "dd MMM hh:mm";
                    imageView.image = image;
                    lblDesc.text = weather?.desc;
                    lblAvgTemp.text = String.init(format: "%1.f˚", (weather?.temperature?.avg)!);
                    lblMinTemp.text =  String.init(format: "%1.f˚", (weather?.temperature?.min)!);
                    lblMaxTemp.text =  String.init(format: "%1.f˚", (weather?.temperature?.max)!);
                    lblLocation.text = weatherResult?.locationName;
                    lblDateTime.text = formatter.string(from: (weather?.timeStamp)!);
                    
                    weatherView.isHidden = false;
                }
                catch {
                    
                }
                
                
            }
            
            
            callout.isAccessoryButtonHidden = true;
            
            
        }
        catch let error as NSError {
            print("error: \(error.description)")
        }
        
        
        
        return true;
    }
    
    func didClickAccessoryButton(for callout: AGSCallout!) {
        self.performSegue(withIdentifier: "detailSegue", sender: nil);
    }
    
    //MARK: Layer delegate
    func mapViewDidLoad(_ mapView: AGSMapView!) {
        mapView.locationDisplay.startDataSource()
        
        let env = AGSEnvelope(xmin: 10458701.000000, ymin: 542977.875000,
                              xmax: 11986879.000000, ymax: 2498290.000000,
                              spatialReference: AGSSpatialReference.webMercator());
        mapView.zoom(to: env, animated: true);
        
        mapView.addMapLayer(graphicLayer, withName: "GraphicLyaer");
        
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
