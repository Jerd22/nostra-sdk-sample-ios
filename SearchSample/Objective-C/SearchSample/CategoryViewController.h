//
//  CategoryViewController.h
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>
#import "ResultViewController.h"
@interface CategoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *_tableView;
    
    NSArray *_categories;
}
@end
