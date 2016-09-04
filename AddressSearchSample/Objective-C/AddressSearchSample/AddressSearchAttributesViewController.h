//
//  AddressSearchAttributesViewController.h
//  AddressSearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <NOSTRASDK/NOSTRASDK.h>

#import "AddressSearchResultViewController.h"

@interface AddressSearchAttributesViewController : UIViewController {
    __weak IBOutlet UITextField *_txtHouseNo;
    __weak IBOutlet UITextField *_txtMoo;
    __weak IBOutlet UITextField *_txtSoi;
    __weak IBOutlet UITextField *_txtRoad;
    __weak IBOutlet UITextField *_txtAdminLevel1;
    __weak IBOutlet UITextField *_txtAdminLevel2;
    __weak IBOutlet UITextField *_txtAdminLevel3;
    __weak IBOutlet UITextField *_txtPostcode;
}

@end
