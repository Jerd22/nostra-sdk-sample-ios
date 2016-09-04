//
//  FuelMapViewController.m
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "FuelMapViewController.h"
#define REFERRER @""

@implementation FuelMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMap];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"resultSegue"]) {
        AGSPoint *point = [AGSPoint pointFromDecimalDegreesString:[_mapView.mapAnchor decimalDegreesStringWithNumDigits:7]
                                             withSpatialReference:[AGSSpatialReference wgs84SpatialReference]];
        FuelResultVenderViewController *fuelVenderViewController = segue.destinationViewController;
        fuelVenderViewController.lat = point.y;
        fuelVenderViewController.lon = point.x;
    }
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
    NSError *error = nil;
    // Get Map Permission
    _mapView.layerDelegate = self;
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
