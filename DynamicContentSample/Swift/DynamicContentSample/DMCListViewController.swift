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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        let result = results[indexPath.row];
        cell?.textLabel?.text = result.name_L;
        cell?.detailTextLabel?.text = result.address_L;
        do {
            let url = URL(string: result.mapIcon);
            let data = try Data(contentsOf: url!);
            let icon = UIImage(data: data);
            cell?.imageView?.image = icon;
        }
        catch {
            
        }
        
        
        return cell!;
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = results[indexPath.row];
        self.performSegue(withIdentifier: "resulttoDetailSegue", sender: result)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results != nil ? results.count : 0;
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "resulttoDetailSegue" {
            let detailViewController = segue.destination as! DMCDetailViewController;
            detailViewController.result = sender as! NTDynamicContentResult;
        }
    }

}
