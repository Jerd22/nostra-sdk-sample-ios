//
//  DMCDetailViewController.swift
//  DynamicContentSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK
class DMCDetailViewController: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAdd_Info: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblTelNo: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    
    var result: NTDynamicContentResult! = nil;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblName.text = result.name_L;
        lblAddress.text = result.address_L;
        lblAdd_Info.text = result.addInfo_L;
        lblDetail.text = result.detail_L;
        lblTelNo.text = result.telNo;
        lblWebsite.text = result.website;
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnShare_Clicked(_ sender: AnyObject) {
        
        do {
            let location = NTLocation(name: result.name_L, lat: result.lat, lon: result.lon);
            let param = NTShortLinkParameter(stops: [location]);
            let shareResult = try NTShortLinkService.execute(param);
            
            let alertController = UIAlertController(title: "Share", message: shareResult.result, preferredStyle: .alert);
            let actionCopy = UIAlertAction(title: "Copy", style: .default, handler: { (action) in
                UIPasteboard.general.string = shareResult.result;
            })
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
            
            alertController.addAction(actionCopy);
            alertController.addAction(actionCancel);
            
            self.present(alertController, animated: true, completion: nil);
        }
        catch {}
        
        
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailtoMapSegue" {
            let mapViewController = segue.destination as! DMCMapViewController;
            mapViewController.result = result;
        }
    }


}
