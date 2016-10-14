//
//  KeywordViewcontroller.swift
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

import UIKit
import NOSTRASDK

class KeywordViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var keywords: [NTAutocompleteResult]?;
    
    var param: NTAutocompleteParameter?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "keywordtoResultSegue" {
            let resultViewController = segue.destination as! ResultViewController;
            
            resultViewController.searchByKeyword(sender as? String);
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count > 0 {
            param = NTAutocompleteParameter(keyword: searchText);
            
            NTAutocompleteService.executeAsync(param!) { (resultSet, error) in
                
                DispatchQueue.main.async(execute: {
                    if error == nil {
                        self.keywords = resultSet?.results;
                    }
                    else {
                        self.keywords = [];
                        print("error: \(error?.description)");
                    }
                    self.tableView.reloadData();
                })
                
            }
        }
        
        
        
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder();
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = keywords![indexPath.row];
        self.performSegue(withIdentifier: "keywordtoResultSegue", sender: keyword.name);
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        let keyword = keywords![indexPath.row];
        
        cell?.textLabel?.text = keyword.name;
        
        return cell!;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywords != nil ? (keywords?.count)! : 0;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
}
