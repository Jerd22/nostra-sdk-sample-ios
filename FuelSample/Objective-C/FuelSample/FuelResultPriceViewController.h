//
//  FuelResultPriceViewController.h
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>

@interface FuelResultPriceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_fuelTypes;
}

@property (nonatomic, strong) NTFuelResult *result;

@end
