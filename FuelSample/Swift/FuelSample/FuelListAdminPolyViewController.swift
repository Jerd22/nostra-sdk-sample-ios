//
//  FuelListAdminPolyViewController.swift
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK

protocol FuelListAdminPolyDelegate {
    func didFinishSelectProvice(provice: NTAdministrativeResult);
    func didFinishSelectAmphoe(amphoe: NTAdministrativeResult);
}

class FuelListAdminPolyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var adminLevel1: String?;
    
    var results: [NTAdministrativeResult]?;
    var delegate: FuelListAdminPolyDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let param = NTAdministrativeParameter();
        
        if adminLevel1 != nil {
            param.adminLevel1 = adminLevel1!;
            
        }
        do {
            let resultSet = try NTAdministrativeService.execute(param);
            results = resultSet.results;
        }
        catch let error as NSError {
            print("error: \(error.description)")
        }
        
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell");
        
        let result = results![indexPath.row];
        cell?.textLabel?.text = result.name_L;
        
        return cell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let result = results![indexPath.row];
        if adminLevel1 == nil {
            delegate?.didFinishSelectProvice(result);
        }
        else
        {
            delegate?.didFinishSelectAmphoe(result);
        }
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results != nil ? (results?.count)! : 0;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
}
