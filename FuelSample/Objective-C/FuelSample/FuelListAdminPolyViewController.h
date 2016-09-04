//
//  FuelListAdminPolyViewController.h
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>

@protocol FuelListAdminPolyDelegate <NSObject>

- (void)didFinishSelectProvice:(NTAdministrativeResult *)province;
- (void)didFinishSelectAmphoe:(NTAdministrativeResult *)amphoe;

@end

@interface FuelListAdminPolyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_results;
}


@property (nonatomic, strong) id<FuelListAdminPolyDelegate> delegate;
@property (nonatomic, strong) NSString *adminLevel1;

@end
