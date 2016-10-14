//
//  TravelByViewController.swift
//  MultiModalSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol TravelByDelegate {
    func didFinishSelectTravelMode(_ travels: [NTMultiModalTransportMode]);
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

    override func didMove(toParentViewController parent: UIViewController?) {
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
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath);
        cell?.accessoryType = .checkmark;
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath);
        cell?.accessoryType = .none;
    }
    
}
