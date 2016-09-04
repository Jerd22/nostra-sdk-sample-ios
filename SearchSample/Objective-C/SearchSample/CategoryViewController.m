
//
//  CategoryViewController.m
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "CategoryViewController.h"

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NTCategoryService executeAsync:^(NTCategoryResultSet * resultSet, NSError * error) {
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _categories = resultSet.results;
                [_tableView reloadData];
            });
        }
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"categorytoResultSegue"]) {
        ResultViewController *resultViewController = segue.destinationViewController;
        [resultViewController searchByCategory:sender];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NTCategoryResult *category = _categories[indexPath.row];
    [self performSegueWithIdentifier:@"categorytoResultSegue" sender:category.code];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NTCategoryResult *category = _categories[indexPath.row];
    cell.textLabel.text = category.name_L;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categories != nil ? _categories.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
