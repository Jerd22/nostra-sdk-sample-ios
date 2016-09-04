//
//  TravelByViewController.m
//  MultiModalSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "TravelByViewController.h"

@implementation TravelByViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    [_delegate didSelectRowAtIndex:indexPath.row];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [_delegate didDeselectRowAtIndex:indexPath.row];
}

@end
