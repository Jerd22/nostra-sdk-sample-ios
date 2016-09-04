//
//  FuelAdminPolyViewController.h
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <NOSTRASDK/NOSTRASDK.h>

#import "FuelListAdminPolyViewController.h"
#import "FuelResultVenderViewController.h"
@interface FuelAdminPolyViewController : UIViewController <FuelListAdminPolyDelegate>
{
    
    NTAdministrativeResult *_amphoe;
    NTAdministrativeResult *_province;
    
    __weak IBOutlet UIButton *_btnProvince;
    __weak IBOutlet UIButton *_btnAmphoe;
}
@end
