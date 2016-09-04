//
//  TravelByViewController.h
//  MultiModalSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>

@protocol TravelByViewControllerDelegate <NSObject>

- (void)didSelectRowAtIndex:(NSInteger)index;
- (void)didDeselectRowAtIndex:(NSInteger)index;

@end
@interface TravelByViewController : UITableViewController

@property (nonatomic, strong) id<TravelByViewControllerDelegate> delegate;
@end
