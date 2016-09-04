//
//  FuelAdminPolyViewController.m
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "FuelAdminPolyViewController.h"

@implementation FuelAdminPolyViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"provinceSegue"]) {
        FuelListAdminPolyViewController *fuelListAdminiViewController = segue.destinationViewController;
        fuelListAdminiViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"amphoeSegue"]) {
        FuelListAdminPolyViewController *fuelListAdminiViewController = segue.destinationViewController;
        fuelListAdminiViewController.delegate = self;
        fuelListAdminiViewController.adminLevel1 = _province.code;
        
    }
    else if ([segue.identifier isEqualToString:@"resultSegue"]) {
        FuelResultVenderViewController *fuelResultVenderViewController = segue.destinationViewController;
        fuelResultVenderViewController.adminLevel1 = _province.code;
        fuelResultVenderViewController.adminLevel2 = _amphoe.code;
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    BOOL ret = true;
    
    if ([identifier isEqualToString:@"amphoeSegue"]) {
        ret = _province != nil;
    }
    else if ([identifier isEqualToString:@"resultSegue"]) {
        ret = _province != nil && _amphoe != nil;
    }
    
    return ret;
}

- (void)didFinishSelectAmphoe:(NTAdministrativeResult *)amphoe {
    _amphoe = amphoe;
    [_btnAmphoe setTitle:_amphoe.name_L forState:UIControlStateNormal];
}

- (void)didFinishSelectProvice:(NTAdministrativeResult *)province {
    _province = province;
    [_btnProvince setTitle:_province.name_L forState:UIControlStateNormal];
}

@end
