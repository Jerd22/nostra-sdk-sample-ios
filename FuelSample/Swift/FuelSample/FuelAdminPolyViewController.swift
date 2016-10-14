//
//  FuelAdminiPolyViewController.swift
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK

class FuelAdminPolyViewController: UIViewController, FuelListAdminPolyDelegate {

    var province: NTAdministrativeResult?;
    var amphoe: NTAdministrativeResult?;
    
    @IBOutlet weak var btnProvince: UIButton!
    @IBOutlet weak var btnAmphoe: UIButton!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "provinceSegue" {
            let adminPolyListViewController = segue.destination as? FuelListAdminPolyViewController;
            adminPolyListViewController?.delegate = self;
            
        } else if segue.identifier == "amphoeSegue" {
            let adminPolyListViewController = segue.destination as? FuelListAdminPolyViewController;
            adminPolyListViewController?.delegate = self;
            adminPolyListViewController?.adminLevel1 = province?.code;
        } else if segue.identifier == "resultSegue" {
            let resultViewController = segue.destination as? FuelResultVendorViewController;
            resultViewController?.adminLevel1 = province?.code;
            resultViewController?.adminLevel2 = amphoe?.code;
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var ret = true;
        
        if identifier == "amphoeSegue" {
            ret = province != nil;
        } else if identifier == "resultSegue" {
            ret = province != nil && amphoe != nil;
        }
        
        
        return ret;
    }
    
    func didFinishSelectProvice(_ provice: NTAdministrativeResult) {
        self.province = provice;
        btnProvince.setTitle(province?.name_L, for: .normal);
    }
    
    func didFinishSelectAmphoe(_ amphoe: NTAdministrativeResult) {
        self.amphoe = amphoe;
        btnAmphoe.setTitle(amphoe.name_L, for: .normal);
    }
    
}
