//
//  DMCMapViewController.m
//  DynamicContentSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "DMCMapViewController.h"

#define REFERRER @""

@implementation DMCMapViewController

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
    
    _graphicLayer = [[AGSGraphicsLayer alloc] init];
    [mapView addMapLayer:_graphicLayer withName:@"GraphicLayer"];
    
}

- (BOOL)callout:(AGSCallout *)callout willShowForFeature:(id<AGSFeature>)feature layer:(AGSLayer<AGSHitTestable> *)layer mapPoint:(AGSPoint *)mapPoint {
    callout.title = _result.name_L;
    callout.detail = _result.address_L;
    callout.accessoryButtonHidden = true;
    return true;
}


- (void)layerDidLoad:(AGSLayer *)layer {
    if (_result != nil) {
        AGSPoint *point = [AGSPoint pointWithX:_result.lon y:_result.lat
                              spatialReference:[AGSSpatialReference wgs84SpatialReference]];
        AGSPoint *mappoint = [AGSPoint pointFromDecimalDegreesString:[point decimalDegreesStringWithNumDigits:7] withSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
        [_mapView zoomToScale:1000 withCenterPoint:mappoint animated:true];
        
        AGSSymbol *symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"pin_map"];
        AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:mappoint symbol:symbol attributes:nil];
        
        [_graphicLayer addGraphic:graphic];
        
        [_mapView.callout showCalloutAtPoint:mappoint forFeature:graphic layer:_graphicLayer animated:true];
    }
}


- (void)initializeMap {

    _mapView.callout.delegate = self;
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
