//
//  AddressSearchKeywordViewController.swift
//  AddressSearchSample
//
//  Created by Itthisak Phueaksri on 5/15/2559 BE.
//  Copyright © 2559 gissoft. All rights reserved.
//

import UIKit
import NOSTRASDK
class AddressSearchKeywordViewController: UIViewController {

    @IBOutlet weak var txtKeyword: UITextField!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "resultSegue" {
            let resultViewController = segue.destinationViewController as? AddressSearchResultViewController;
            
            let param = NTAddressSearchParameter(keyword: txtKeyword.text!);
            
            resultViewController?.addressSearchParam = param;
            
        }
    }
    

}
