//
//  DMCListViewController.swift
//  DynamicContentSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK

class DMCListViewController: UITableViewController {

    var dmcResult: NTDynamicContentListResult! = nil;
    var results:[NTDynamicContentResult]! = nil;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            let param = NTDynamicContentParameter(layerId: dmcResult.layerId, lat: 13, lon: 100);
            
            let resultSet = try NTDynamicContentService.execute(param)
            
            results = resultSet.results;
            
        }
        catch {}

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell");
        let result = results[indexPath.row];
        cell?.textLabel?.text = result.name_L;
        cell?.detailTextLabel?.text = result.address_L;
        
        let url = NSURL(string: result.mapIcon);
        let data = NSData(contentsOfURL: url!);
        let icon = UIImage(data: data!);
        cell?.imageView?.image = icon;
        
        return cell!;
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let result = results[indexPath.row];
        self.performSegueWithIdentifier("resulttoDetailSegue", sender: result)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results != nil ? results.count : 0;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "resulttoDetailSegue" {
            let detailViewController = segue.destinationViewController as! DMCDetailViewController;
            detailViewController.result = sender as! NTDynamicContentResult;
        }
    }

}
