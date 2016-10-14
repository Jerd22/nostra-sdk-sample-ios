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
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    self.categories = resultSet?.results!;
                }
                else {
                    print("error \(error?.description)");
                }
                self.tableView.reloadData();
                
            });
            
        }
        
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categorytoResultSegue" {
            let resultViewController = segue.destination as! ResultViewController;
            
            resultViewController.searchByCategory(sender as? String);
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let category = categories[indexPath.row];
        self.performSegue(withIdentifier: "categorytoResultSegue", sender: category.code);
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        let category = categories[indexPath.row];
        
        cell?.textLabel?.text = category.name_E;
        
        return cell!;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories != nil ? (categories?.count)! : 0;
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }

    
}
