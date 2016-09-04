//
//  AddressSearchAttributesViewController.m
//  AddressSearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "AddressSearchAttributesViewController.h"

@implementation AddressSearchAttributesViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"resultSegue"]) {
        AddressSearchResultViewController *addressSearchResultViewController = segue.destinationViewController;
        NTAddressSearchParameter *param = [[NTAddressSearchParameter alloc] init];
        param.houseNo = _txtHouseNo.text;
        param.moo = _txtMoo.text;
        param.soi = _txtSoi.text;
        param.road = _txtSoi.text;
        param.adminLevel1 = _txtAdminLevel1.text;
        param.adminLevel2 = _txtAdminLevel2.text;
        param.adminLevel3 = _txtAdminLevel3.text;
        param.postcode = _txtPostcode.text;
        
        addressSearchResultViewController.param = param;
    }
}

@end
