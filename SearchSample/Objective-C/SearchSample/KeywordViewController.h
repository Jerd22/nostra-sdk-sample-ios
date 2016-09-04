//
//  KeywordViewController.h
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>
#import "ResultViewController.h"
@interface KeywordViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    
    __weak IBOutlet UISearchBar *_searchText;
    __weak IBOutlet UITableView *_tableView;
    
    
    NSArray *_keywords;
    
}

@end
