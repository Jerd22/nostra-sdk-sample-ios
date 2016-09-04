//
//  MarkOnMapViewController.m
//  MultiModalSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "MarkOnMapViewController.h"

#define REFERRER @""

@implementation MarkOnMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMap];
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

- (IBAction)btnOk_Clicked:(id)sender {
    if (_isFromLocation) {
        [_delegate didFinishSelectFromLocation:_mapView.mapAnchor];
    }
    else {
        [_delegate didFinishSelectToLocation:_mapView.mapAnchor];
    }
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
            tiled.delegate = self;
            
            [_mapView addMapLayer:tiled withName:mapPermission.serviceName];
            
        }
    }
    else {
        NSLog(@"load map permission error: %@", error.localizedDescription);
    }
}

@end
