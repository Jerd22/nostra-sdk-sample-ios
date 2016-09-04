//
//  ResultViewController.m
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "ResultViewController.h"

@implementation ResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)searchByKeyword:(NSString *)keyword {
    if (keyword != nil) {
        NTLocationSearchParameter *param = [[NTLocationSearchParameter alloc] initWithKeyword:keyword
                                                                                          lat:13.763232
                                                                                          lon:100.538304];

        [self searchWithParam:param];
    }
}

- (void)searchByCategory:(NSString *)category {
    if (category != nil ) {
        NTLocationSearchParameter *param = [[NTLocationSearchParameter alloc] initWithCategoryCode:@[category]
                                                                                               lat:13.763232
                                                                                               lon:100.538304];
        [self searchWithParam:param];
    }
}

- (void)searchByLocalCategory:(NSString *)localCategory {
    if (localCategory != nil ) {
        NTLocationSearchParameter *param = [[NTLocationSearchParameter alloc] initWithLocalCategoryCode:@[localCategory]
                                                                                                    lat:13.763232
                                                                                                    lon:100.538304];

        [self searchWithParam:param];
    }
}

- (void)searchWithParam:(NTLocationSearchParameter *)param {
    [NTLocationSearchService executeAsync:param Completion:^(NTLocationSearchResultSet * resultSet, NSError * error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _result = resultSet.results;
                [_tableView reloadData];
            });
        }
        else {
            NSLog(@"error: %@",error.localizedDescription);
        }
    }];
}

- (void)performUnabletoSearch {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unable to search" message:@"Please check your location." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mapResultSegue"]) {
        MapResultViewController *mapResultViewController = segue.destinationViewController;
        mapResultViewController.result = sender;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NTLocationSearchResult *result = _result[indexPath.row];
    
    [self performSegueWithIdentifier:@"mapResultSegue" sender:result];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NTLocationSearchResult *result = _result[indexPath.row];
    
    cell.textLabel.text = result.name_L;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@", result.adminLevel3_L, result.adminLevel2_L, result.adminLevel1_L];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _result != nil ? _result.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


@end
