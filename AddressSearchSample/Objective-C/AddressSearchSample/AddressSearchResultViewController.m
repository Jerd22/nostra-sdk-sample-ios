//
//  AddressSearchResultViewController.m
//  AddressSearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "AddressSearchResultViewController.h"

@implementation AddressSearchResultViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [NTAddressSearchService executeAsync:_param Completion:^(NTAddressSearchResultSet * resultSet, NSError * error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _results = resultSet.results;
                [_tableView reloadData];
            });
            
        }
    }];
    
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mapViewSegue"]) {
        AddressSearchMapResultViewController *addressSearchMapResultViewController = segue.destinationViewController;
        addressSearchMapResultViewController.result = sender;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NTAddressSearchResult *result = _results[indexPath.row];
    [self performSegueWithIdentifier:@"mapViewSegue" sender:result];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NTAddressSearchResult *result = _results[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",result.houseNo, result.soi_L];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@",result.adminLevel3_L, result.adminLevel2_L, result.adminLevel1_L];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _results != nil ? _results.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
@end
