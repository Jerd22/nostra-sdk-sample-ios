//
//  LocalCategoryViewController.m
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "LocalCategoryViewController.h"

@implementation LocalCategoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NTLocalCategoryService executeAsync:nil
                              Completion:^(NTLocalCategoryResultSet *resultSet, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _localCategories = resultSet.results;
            [_tableView reloadData];
        });
    }];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"localCategorytoResultSegue"]) {
        ResultViewController *resultViewController = segue.destinationViewController;
        [resultViewController searchByLocalCategory:sender];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NTCategoryResult *category = _localCategories[indexPath.row];
    [self performSegueWithIdentifier:@"localCategorytoResultSegue" sender:category.code];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NTCategoryResult *localCategory = _localCategories[indexPath.row];
    cell.textLabel.text = localCategory.name_L;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _localCategories != nil ? _localCategories.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
