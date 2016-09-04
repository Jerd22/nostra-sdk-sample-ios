//
//  TravelByViewController.swift
//  MultiModalSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK

protocol TravelByDelegate {
    func didFinishSelectTravelMode(travels: [NTMultiModalTransportMode]);
}

class TravelByViewController: UITableViewController {

    var delegate: TravelByDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            var travels:[NTMultiModalTransportMode] = []
            
            if tableView.indexPathsForSelectedRows?.count > 0 {
                for indexPath in tableView.indexPathsForSelectedRows! {
                    travels.append(NTMultiModalTransportMode(rawValue: indexPath.row)!);
                }
                delegate?.didFinishSelectTravelMode(travels);
            }

            
        }
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        cell?.accessoryType = .Checkmark;
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        cell?.accessoryType = .None;
    }
    
}
