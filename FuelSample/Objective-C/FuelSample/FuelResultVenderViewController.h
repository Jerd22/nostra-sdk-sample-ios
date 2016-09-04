//
//  FuelResultVenderViewController.h
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <NOSTRASDK/NOSTRASDK.h>

#import "FuelResultPriceViewController.h"
@interface FuelResultVenderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_results;
}

@property (nonatomic, strong) NSString *adminLevel1;
@property (nonatomic, strong) NSString *adminLevel2;

@property (nonatomic, readwrite) double lat;
@property (nonatomic, readwrite) double lon;

@end
