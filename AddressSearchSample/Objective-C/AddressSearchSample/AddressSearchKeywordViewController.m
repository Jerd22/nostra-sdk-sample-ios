//
//  AddressSearchKeywordViewController.m
//  AddressSearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "AddressSearchKeywordViewController.h"

@implementation AddressSearchKeywordViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"resultSegue"]) {
        AddressSearchResultViewController *addressSearchResultViewController = segue.destinationViewController;
        NTAddressSearchParameter *param = [[NTAddressSearchParameter alloc] initWithKeyword:_txtKeyword.text];
        addressSearchResultViewController.param = param;
    }
}

@end
