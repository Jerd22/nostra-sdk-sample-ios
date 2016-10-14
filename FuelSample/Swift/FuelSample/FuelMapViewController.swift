//
//  FuelMapViewController.swift
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK
import ArcGIS

class FuelMapViewController: UIViewController, AGSLayerDelegate {
    
    let referrer = ""

    @IBOutlet weak var mapView: AGSMapView!
    
    @IBOutlet var btnOk: UIButton!
    
    
    var isFromLocation = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        initializeMap()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSegue" {

            let point = AGSPoint(fromDecimalDegreesString: mapView.mapAnchor.decimalDegreesString(withNumDigits: 7),
                                 with: AGSSpatialReference.wgs84());
            let resultViewController = segue.destination as? FuelResultVendorViewController;
            resultViewController?.lat = point?.y;
            resultViewController?.lon = point?.x;
        }
    }
    
    
    @IBAction func btnOk_Clicked(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "resultSegue", sender: nil);
        
    }
    
    
    func initializeMap() {

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
    
    func layerDidLoad(_ layer: AGSLayer!) {
        print("\(layer.name) was loaded");
    }
    
    func layer(_ layer: AGSLayer!, didFailToLoadWithError error: Error!) {
        print("\(layer.name) failed to load by reason: \(error)");
    }
}
