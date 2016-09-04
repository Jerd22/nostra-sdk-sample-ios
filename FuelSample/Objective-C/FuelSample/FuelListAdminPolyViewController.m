//
//  FuelListAdminPolyViewController.m
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "FuelListAdminPolyViewController.h"

@implementation FuelListAdminPolyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NTAdministrativeParameter *param = [[NTAdministrativeParameter alloc] init];
    
    if (_adminLevel1 != nil) {
        param.adminLevel1 = _adminLevel1;
    }
    
    NSError *error = nil;
    
    NTAdministrativeResultSet *resultSet = [NTAdministrativeService execute:param error:&error];
    
    if (!error) {
        _results = resultSet.results;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NTAdministrativeResult *result = _results[indexPath.row];
    
    if (_adminLevel1) {
        [_delegate didFinishSelectAmphoe:result];
    }
    else {
        [_delegate didFinishSelectProvice:result];
    }
    [self.navigationController popViewControllerAnimated:true];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NTAdministrativeResult *result = _results[indexPath.row];
    
    cell.textLabel.text = result.name_L;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _results != nil ? _results.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
