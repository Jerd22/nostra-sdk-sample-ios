
//
//  MainDMCViewController.m
//  DynamicContentSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "MainDMCViewController.h"

#define REFERRER @""

@implementation MainDMCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMap];
    
    NSError *error = nil;
    NTDynamicContentListResultSet *resultSet = [NTDynamicContentListService executeAndReturnError:&error];
    
    if (!error) {
        _result = resultSet.results;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"maintoDMCListSegue"]) {
        DMCListViewController *dmcListViewController = segue.destinationViewController;
        dmcListViewController.dmcResult = sender;
    }
}



- (IBAction)btnLayer_Clicked:(id)sender {
    if (_tableViewLeading.constant == 0) {
        [self btnHideMenu_Clicked:sender];
        _btnHideMenu.hidden = true;
        
    }
    else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        [_tableViewLeading setConstant:0];
        [UIView commitAnimations];

        _btnHideMenu.hidden = false;
    }
}


- (IBAction)btnHideMenu_Clicked:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [_tableViewLeading setConstant:-180];
    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NTDynamicContentListResult *result = _result[indexPath.row];
    
    [self performSegueWithIdentifier:@"maintoDMCListSegue" sender:result];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NTDynamicContentListResult *result = _result[indexPath.row];
    
    cell.textLabel.text = result.name_L;
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _result != nil ? _result.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)mapViewDidLoad:(AGSMapView *)mapView {
    
    [mapView.locationDisplay startDataSource];
    
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:10458701.000000
                                                ymin:542977.875000
                                                xmax:11986879.000000
                                                ymax:2498290.000000
                                    spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    [mapView zoomToEnvelope:env animated:true];
    
    
}

- (void)initializeMap {
    _mapView.layerDelegate = self;
    NSError *error = nil;
    // Get Map Permission
    NTMapPermissionResultSet *resultSet = [NTMapPermissionService executeAndReturnError:&error];
    
    if (!error) {
        
        // Get Street map HD (service id: 2)
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serviceId == 2"];
        NSArray *filtered = [resultSet.results filteredArrayUsingPredicate:predicate];
        
        if (filtered.count > 0) {
            NTMapPermissionResult *mapPermission = filtered.firstObject;
            
            NSURL *url = [NSURL URLWithString:mapPermission.serviceUrl_L];
            AGSCredential *cred = [[AGSCredential alloc] initWithToken:mapPermission.serviceToken_L
                                                               referer:REFERRER];
            
            AGSTiledMapServiceLayer *tiled = [[AGSTiledMapServiceLayer alloc] initWithURL:url
                                                                               credential:cred];

            [_mapView addMapLayer:tiled withName:mapPermission.serviceName];
            
        }
    }
    else {
        NSLog(@"load map permission error: %@", error.localizedDescription);
    }
}

@end
