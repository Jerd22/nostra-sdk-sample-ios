//
//  DMCListViewController.m
//  DynamicContentSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "DMCListViewController.h"

@implementation DMCListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NTDynamicContentParameter *param = [[NTDynamicContentParameter alloc] initWithLayerId:_dmcResult.layerId
                                                                                      lat:13
                                                                                      lon:100];
    
    NSError *error = nil;
    NTDynamicContentResultSet *resultSet = [NTDynamicContentService execute:param error:&error];
    _result = resultSet.results;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"resulttoDetailSegue"]) {
        DMCDetailViewController *dmcDetailViewController = segue.destinationViewController;
        dmcDetailViewController.result = sender;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NTDynamicContentResult *result = _result[indexPath.row];
    cell.textLabel.text = result.name_L;
    cell.detailTextLabel.text = result.address_L;
    
    NSURL *url = [NSURL URLWithString:result.mapIcon];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    cell.imageView.image = [UIImage imageWithData:data];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NTDynamicContentResult *result = _result[indexPath.row];
    
    [self performSegueWithIdentifier:@"resulttoDetailSegue" sender:result];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _result != nil ? _result.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



@end
