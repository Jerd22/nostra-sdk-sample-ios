//
//  RouteDetailViewController.m
//  RouteSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "RouteDetailViewController.h"

@implementation RouteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.estimatedRowHeight = 44.0f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NTDirection *direction = _directions[indexPath.row];
    
    UILabel *lblDirection = (UILabel *)[cell viewWithTag:101];
    UILabel *lblLength = (UILabel *)[cell viewWithTag:102];
    
    lblDirection.text = direction.text;
    lblLength.text = [NSString stringWithFormat:@"%.1f Km.", direction.length /1000];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _directions != nil ? _directions.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
