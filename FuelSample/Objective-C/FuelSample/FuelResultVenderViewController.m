//
//  FuelResultVenderViewController.m
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "FuelResultVenderViewController.h"

@implementation FuelResultVenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NTFuelParameter *param = nil;
    
    if (_adminLevel1 && _adminLevel2) {
        param = [[NTFuelParameter alloc] initWithAdminLevel1:_adminLevel1
                                                 adminLevel2:_adminLevel2];
    }
    else {
        param = [[NTFuelParameter alloc] initWithLat:_lat lon:_lon];
    }
    
    NSError *error = nil;
    
    NTFuelResultSet *resultSet = [NTFuelService execute:param error:&error];
    
    if (!error) {
        _results = resultSet.results;
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"priceSegue"]) {
        FuelResultPriceViewController *fuelResultPriceViewController = segue.destinationViewController;
        NTFuelResult *result = sender;
        fuelResultPriceViewController.title = result.brandName_L;
        fuelResultPriceViewController.result = result;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NTFuelResult *result = _results[indexPath.row];
    [self performSegueWithIdentifier:@"priceSegue" sender:result];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NTFuelResult *result = _results[indexPath.row];
    
    cell.textLabel.text = result.brandName_L;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _results != nil ? _results.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
