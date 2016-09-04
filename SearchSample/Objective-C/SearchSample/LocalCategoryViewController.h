//
//  LocalCategoryViewController.h
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>
#import "ResultViewController.h"
@interface LocalCategoryViewController : UIViewController
{
    __weak IBOutlet UITableView *_tableView;
    NSArray *_localCategories;
}
@end
