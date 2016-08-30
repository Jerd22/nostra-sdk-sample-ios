



//
//  FuelAdminiPolyViewController.swift
//  FuelSample
//
//  Created by Itthisak Phueaksri on 5/15/2559 BE.
//  Copyright © 2559 gissoft. All rights reserved.
//

import UIKit
import NOSTRASDK

class FuelAdminPolyViewController: UIViewController, FuelListAdminPolyDelegate {

    var province: NTAdministrativeResult?;
    var amphoe: NTAdministrativeResult?;
    
    @IBOutlet weak var btnProvince: UIButton!
    @IBOutlet weak var btnAmphoe: UIButton!
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "provinceSegue" {
            let adminPolyListViewController = segue.destinationViewController as? FuelListAdminPolyViewController;
            adminPolyListViewController?.delegate = self;
            
        } else if segue.identifier == "amphoeSegue" {
            let adminPolyListViewController = segue.destinationViewController as? FuelListAdminPolyViewController;
            adminPolyListViewController?.delegate = self;
            adminPolyListViewController?.adminLevel1 = province?.code;
        } else if segue.identifier == "resultSegue" {
            let resultViewController = segue.destinationViewController as? FuelResultVendorViewController;
            resultViewController?.adminLevel1 = province?.code;
            resultViewController?.adminLevel2 = amphoe?.code;
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        var ret = true;
        
        if identifier == "amphoeSegue" {
            ret = province != nil;
        } else if identifier == "resultSegue" {
            ret = province != nil && amphoe != nil;
        }
        
        
        return ret;
    }
    
    func didFinishSelectProvice(provice: NTAdministrativeResult) {
        self.province = provice;
        btnProvince.setTitle(province?.name_L, forState: .Normal);
    }
    
    func didFinishSelectAmphoe(amphoe: NTAdministrativeResult) {
        self.amphoe = amphoe;
        btnAmphoe.setTitle(amphoe.name_L, forState: .Normal);
    }
    
}
