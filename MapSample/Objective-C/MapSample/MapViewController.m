//
//  ViewController.m
//  MapSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "MapViewController.h"

#define REFERRER @""

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_mapView setLayerDelegate:self];

    _basemaps = [@[] mutableCopy];
    _layers = [@[] mutableCopy];
    
    @try {
        
        NSError *error = nil;
        
        _mapResult = [NTMapPermissionService executeAndReturnError:&error];
        
        if (!error) {
            if (_mapResult.results != nil && _mapResult.results.count > 0) {
                NSArray *mapResultSorted = [_mapResult.results sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"sortIndex" ascending:YES]]];
                
                for (NTMapPermissionResult *mapPermission in mapResultSorted) {
                    if (mapPermission.layerType == NTMapLayerTypeBasemap || mapPermission.layerType == NTMapLayerTypeImagery) {
                        [_basemaps addObject:mapPermission];
                    }
                    else if (mapPermission.layerType == NTMapLayerTypeSpecialLayer) {
                        [_layers addObject:mapPermission];
                    }
                    
                    if (mapPermission.serviceId == 2) {
                        [self addLayer:mapPermission];
                    }
                    else {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self addLayer:mapPermission];
                        });
                    }
                    
                }
            }
        }
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
}

- (IBAction)btnShowMenu_Clicked:(id)sender {
    [self showMenu];
}

- (IBAction)btnHideMenu_Clicked:(id)sender {
    [self hideMenu];
}


- (IBAction)btnLockLocation_Clicked:(id)sender {
    [_mapView centerAtPoint:_mapView.locationDisplay.mapLocation
                   animated:true];
}

-(void)showMenu {
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationDuration:0.5];
    _tableViewLeading.constant = 0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    _btnHide.hidden = false;
}

-(void)hideMenu{

    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationDuration:0.5];
    _tableViewLeading.constant = -260;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    _btnHide.hidden = true;
}

- (void)visibleLayer:(BOOL)visible serviceId:(NSInteger)serviceId {
    
    if (_mapResult != nil && _mapResult.results.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serviceId == %d", serviceId];
        NSArray *filtered = [_mapResult.results filteredArrayUsingPredicate:predicate];
        
        if (filtered.count > 0) {
            NTMapPermissionResult *mapPer = filtered.firstObject;
            
            AGSLayer *layer = [_mapView mapLayerForName:mapPer.serviceName];
            
            if (layer != nil) {
                layer.visible = visible;
            }
            
            if (mapPer.dependMap != nil && mapPer.dependMap.count > 0) {
                for (NSNumber *serviceId in mapPer.dependMap) {
                    [self visibleLayer:visible serviceId:serviceId.integerValue];
                }
            }
            
        }
    }
    
}


#pragma Layer delegate
- (void)mapViewDidLoad:(AGSMapView *)mapView
{
    [_mapView.locationDisplay startDataSource];
    
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:10458701.000000
                                                ymin:542977.875000
                                                xmax:11986879.000000
                                                ymax:2498290.000000
                                    spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    [_mapView zoomToEnvelope:env animated:true];
    
    
}

- (void)layerDidLoad:(AGSLayer *)layer
{
    NSLog(@"%@ was loaded", layer.name);
}

- (void)layer:(AGSLayer *)layer didFailToLoadWithError:(NSError *)error
{
    NSLog(@"%@ failed to load by reason: %@",layer.name, error.description);
}

- (void)addLayer:(NTMapPermissionResult *)mapPermission {
    AGSLayer *layer = nil;
    
    NSURL *url = [[NSURL alloc] initWithString:mapPermission.serviceUrl_L];
    
    if (mapPermission.mapServiceType == NTMapServiceTypeTiledMapService) {

        AGSTiledMapServiceLayer *tiledLyr = nil;
        
        if (mapPermission.serviceToken_L != nil && ![mapPermission.serviceToken_L isEqual: @""]) {
            AGSCredential *cred = [[AGSCredential alloc] initWithToken:mapPermission.serviceToken_L referer:REFERRER];
            tiledLyr = [[AGSTiledMapServiceLayer alloc] initWithURL:url credential:cred];
        }
        else {
            tiledLyr = [[AGSTiledMapServiceLayer alloc] initWithURL:url];
            
        }
        
        tiledLyr.delegate = self;
        layer = tiledLyr;
    }
    else if (mapPermission.mapServiceType == NTMapServiceTypeDynamicMapService) {
        AGSDynamicMapServiceLayer *dynamicLyr = nil;
        
        if (mapPermission.serviceToken_L != nil && ![mapPermission.serviceToken_L isEqual: @""]) {
            AGSCredential *cred = [[AGSCredential alloc] initWithToken:mapPermission.serviceToken_L referer:REFERRER];
            dynamicLyr = [[AGSDynamicMapServiceLayer alloc] initWithURL:url credential:cred];
        }
        else {
            dynamicLyr = [[AGSDynamicMapServiceLayer alloc] initWithURL:url];
            
        }
        
        dynamicLyr.delegate = self;
        layer = dynamicLyr;
    }
    else if (mapPermission.mapServiceType == NTMapServiceTypeFeatureService) {
        AGSFeatureLayer *featLayer = nil;
        
        if (mapPermission.serviceToken_L != nil && ![mapPermission.serviceToken_L isEqual: @""]) {
            AGSCredential *cred = [[AGSCredential alloc] initWithToken:mapPermission.serviceToken_L referer:REFERRER];
            featLayer = [[AGSFeatureLayer alloc] initWithURL:url
                                                        mode:AGSFeatureLayerModeOnDemand
                                                  credential:cred];
        }
        else {
            featLayer = [[AGSFeatureLayer alloc] initWithURL:url
                                                        mode:AGSFeatureLayerModeOnDemand];
            
        }
        
        featLayer.delegate = self;
        layer = featLayer;
    }
    else if (mapPermission.mapServiceType == NTMapServiceTypeWebMapService) {
        AGSWMSLayer *wmsLayer = nil;
        
        if (mapPermission.serviceToken_L != nil && ![mapPermission.serviceToken_L isEqual: @""]) {
            AGSCredential *cred = [[AGSCredential alloc] initWithToken:mapPermission.serviceToken_L referer:REFERRER];
            wmsLayer = [[AGSWMSLayer alloc] initWithURL:url credential:cred];
        }
        else {
            wmsLayer = [[AGSWMSLayer alloc] initWithURL:url];
            
        }
        
        wmsLayer.delegate = self;
        layer = wmsLayer;
    }
    else if (mapPermission.mapServiceType == NTMapServiceTypeOpenSteetMap) {
        AGSOpenStreetMapLayer *osmLayer = [AGSOpenStreetMapLayer openStreetMapLayer];
        layer = osmLayer;
    }
    
    if (layer != nil) {
        // layer will be visibled, if service id is 2 (Street map Thailand HD).
        layer.visible = mapPermission.serviceId == 2;
        [_mapView addMapLayer:layer withName:mapPermission.serviceName];
    }
    else {
        NSLog(@"error to intialize layer: \(mapPermission.serviceName)");
    }
}

#pragma Table view delegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (_selectedBasemap != nil) {
            
            UITableViewCell *dCell = [tableView cellForRowAtIndexPath:_selectedBasemap];
            NSInteger serviceId = [self findServiceId:dCell.textLabel.text];
            
            if (serviceId > -1) {
                [self visibleLayer:NO serviceId:serviceId];
            }
            
            [tableView deselectRowAtIndexPath:_selectedBasemap animated:false];
        }
        _selectedBasemap = indexPath;
        
        
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger serviceId = [self findServiceId:cell.textLabel.text];
    
    if (serviceId > -1) {
        [self visibleLayer:YES serviceId:serviceId];
    }
    
    [self hideMenu];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger serviceId = [self findServiceId:cell.textLabel.text];
    
    if (serviceId > -1) {
        [self visibleLayer:NO serviceId:serviceId];
    }
    
    [self hideMenu];
}

- (NSInteger)findServiceId:(NSString *)serviceName {
    NTMapPermissionResult *mapPermission = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serviceName == %@", serviceName];
    
    NSArray *filtered = [_mapResult.results filteredArrayUsingPredicate:predicate];
    
    if (filtered.count > 0) {
        mapPermission = filtered.firstObject;
    }
    
    return mapPermission != nil ? mapPermission.serviceId : -1;
}

#pragma Table view datasource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header"];
    
    if (section == 0)
    {
        [cell.textLabel setText:@"Basemap"];
    }
    else
    {
        [cell.textLabel setText:@"Layer"];
    }
    
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NTMapPermissionResult *service;
    if (indexPath.section == 0)
    {
        service = _basemaps[indexPath.row];
    }
    else
    {
        service = _layers[indexPath.row];
    }
    
    if (service.serviceId == 2) {
        _selectedBasemap = indexPath;
    }
    
    [cell.textLabel setText:service.serviceName];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _basemaps.count;
    }
    else
    {
        return _layers.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

@end
