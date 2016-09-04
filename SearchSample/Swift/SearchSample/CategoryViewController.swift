//
//  CategoryViewcontroller.swift
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var categories: [NTCategoryResult]! = nil;
    
    override func viewDidLoad() {

        NTCategoryService.executeAsync { (resultSet, error) in
            dispatch_async(dispatch_get_main_queue(), {
                
                if error == nil {
                    self.categories = resultSet.results!;
                }
                else {
                    print("error \(error.description)");
                }
                self.tableView.reloadData();
                
            });
            
        }
        
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "categorytoResultSegue" {
            let resultViewController = segue.destinationViewController as! ResultViewController;
            
            resultViewController.searchByCategory(sender as? String);
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let category = categories[indexPath.row];
        self.performSegueWithIdentifier("categorytoResultSegue", sender: category.code);
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell");
        let category = categories[indexPath.row];
        
        cell?.textLabel?.text = category.name_E;
        
        return cell!;
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories != nil ? (categories?.count)! : 0;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
}
