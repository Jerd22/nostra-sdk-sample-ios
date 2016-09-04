//
//  LocalCategoryViewController.swift
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK

class LocalCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var localCateogries: [NTLocalCategoryResult]! = [];
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NTLocalCategoryService.executeAsync(nil, Completion: { (resultSet, error) in
            dispatch_async(dispatch_get_main_queue(), { 
                if error == nil {
                    self.localCateogries = resultSet.results;
                }
                else {
                    print("error \(error.description)");
                }
                self.tableView.reloadData();
            })
            
        });
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "localCategorytoResultSegue" {
            let resultViewController = segue.destinationViewController as! ResultViewController;
            
            resultViewController.searchByLocalCategory(sender as? String);
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let category = localCateogries[indexPath.row];
        self.performSegueWithIdentifier("localCategorytoResultSegue", sender: category.categoryCode);
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell");
        let category = localCateogries[indexPath.row];
        
        cell?.textLabel?.text = category.name_E;
        
        return cell!;
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localCateogries != nil ? (localCateogries?.count)! : 0;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
