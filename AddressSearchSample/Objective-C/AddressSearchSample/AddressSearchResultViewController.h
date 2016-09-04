//
//  AddressSearchResultViewController.h
//  AddressSearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>
#import "AddressSearchMapResultViewController.h"

@interface AddressSearchResultViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *_tableView;
    NSArray *_results;
}

@property (nonatomic, strong) NTAddressSearchParameter *param;
@end
