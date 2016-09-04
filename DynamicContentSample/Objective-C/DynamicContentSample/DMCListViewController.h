//
//  DMCListViewController.h
//  DynamicContentSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>
#import "DMCDetailViewController.h"
@interface DMCListViewController : UITableViewController
{
    NSArray *_result;
}
@property (nonatomic, strong) NTDynamicContentListResult *dmcResult;

@end
