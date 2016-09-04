//
//  ResultViewController.h
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <NOSTRASDK/NOSTRASDK.h>

#import "MapResultViewController.h"

@interface ResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *_tableView;
    
    NSArray *_result;
}

- (void)searchByKeyword:(NSString *)keyword;
- (void)searchByCategory:(NSString *)category;
- (void)searchByLocalCategory:(NSString *)localCategory;
@end
