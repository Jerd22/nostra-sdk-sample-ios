//
//  KeywordViewController.m
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "KeywordViewController.h"


@implementation KeywordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"keywordtoResultSegue"]) {
        ResultViewController *resultViewController = segue.destinationViewController;
        [resultViewController searchByKeyword:sender];

    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        NTAutocompleteParameter *param = [[NTAutocompleteParameter alloc] initWithKeyword:searchText];
        
        [NTAutocompleteService executeAsync:param Completion:^(NTAutocompleteResultSet * resultSet, NSError *error) {
            if (!error) {
                _keywords = resultSet.results;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NTAutocompleteResult *keyword = _keywords[indexPath.row];
    [self performSegueWithIdentifier:@"keywordtoResultSegue" sender:keyword.name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NTAutocompleteResult *keyword = _keywords[indexPath.row];
    cell.textLabel.text = keyword.name;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _keywords != nil ? _keywords.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


@end
