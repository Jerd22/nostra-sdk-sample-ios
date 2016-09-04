//
//  RouteDetailViewController.h
//  RouteSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>
@interface RouteDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_tableView;
    
}

@property (nonatomic, strong) NSArray *directions;

@end
