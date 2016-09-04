//
//  FuelResultPriceViewController.m
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "FuelResultPriceViewController.h"

@implementation FuelResultPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fuelTypes = @[@"Diesel",@"Diesel Premium",@"Gasohol91",@"Gasohol95",@"GasoholE20",@"GasoholE85",@"Gasoline91",@"Gasoline95",@"NGV"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    UILabel *lblType = (UILabel *)[tableView viewWithTag:101];
    UILabel *lblPrice = (UILabel *)[tableView viewWithTag:102];
    
    lblType.text = _fuelTypes[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            lblPrice.text = [NSString stringWithFormat:@"%.2f",_result.diesel];
        case 1:
            lblPrice.text = [NSString stringWithFormat:@"%.2f",_result.dieselPremium];
        case 2:
            lblPrice.text = [NSString stringWithFormat:@"%.2f",_result.gasohol91];
            break;
        case 3:
            lblPrice.text = [NSString stringWithFormat:@"%.2f",_result.gasohol95];
            break;
        case 4:
            lblPrice.text = [NSString stringWithFormat:@"%.2f",_result.gasoholE20];
            break;
        case 5:
            lblPrice.text = [NSString stringWithFormat:@"%.2f",_result.gasoholE85];
            break;
        case 6:
            lblPrice.text = [NSString stringWithFormat:@"%.2f",_result.gasoline91];
            break;
        case 7:
            lblPrice.text = [NSString stringWithFormat:@"%.2f",_result.gasoline95];
            break;
        default:
            lblPrice.text = [NSString stringWithFormat:@"%.2f",_result.NGV];
            break;
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fuelTypes.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



@end
