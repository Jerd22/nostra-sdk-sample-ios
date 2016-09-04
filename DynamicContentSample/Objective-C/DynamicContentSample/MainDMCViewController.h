//
//  MainDMCViewController.h
//  DynamicContentSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <NOSTRASDK/NOSTRASDK.h>
#import "DMCListViewController.h"

@interface MainDMCViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AGSMapViewLayerDelegate>
{
    
    __weak IBOutlet AGSMapView *_mapView;
    __weak IBOutlet UIButton *_btnHideMenu;
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet NSLayoutConstraint *_tableViewLeading;
    
    NSArray *_result;
}
@end
