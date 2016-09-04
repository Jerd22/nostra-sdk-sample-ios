//
//  MultiModalMainViewController.m
//  MultiModalSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "MultiModalMainViewController.h"

#define REFERRER @""

@implementation MultiModalMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMap];
    _param = [[NTMultiModalTransportParamter alloc] init];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fromLocationSegue"] || [segue.identifier isEqualToString:@"toLocationSegue"]) {
        MarkOnMapViewController *markOnMapViewController = segue.destinationViewController;
        markOnMapViewController.delegate = self;
        markOnMapViewController.isFromLocation = [segue.identifier isEqualToString:@"fromLocationSegue"];
    }
    else if ([segue.identifier isEqualToString:@"travelBySegue"]) {
        TravelByViewController *travelByViewController = segue.destinationViewController;
        travelByViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"routeDetailSegue"]) {
//        RouteDetailViewController *routeDetailViewCotroller = segue.destinationViewController;
//        routeDetailViewCotroller.directions = _routeResult.directions;
    }
    
}

- (IBAction)btnCalculateRoute_Clicked:(id)sender {
    
    if (_toLocation != nil && _fromLocation != nil) {
        NSError *error = nil;
        
        
        _param.stops = @[_fromLocation, _toLocation];
        
        _result = [NTMultiModalTransportService execute:_param error:&error];
        
        if (error)
        {
            NSMutableArray *geometries = [@[] mutableCopy];
            
            for (NTMultiModalDirection *direction in _result.minute.directions) {
                
                AGSPolyline *line = [[AGSPolyline alloc] initWithJSON:[direction getShape] spatialReference:[AGSSpatialReference wgs84SpatialReference]];
                
                AGSGeometry *geometry = [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:line
                                                                                toSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
                
                
                UIColor *color = [UIColor colorWithRed:63.0/255.0
                                                 green:81.0/255.0
                                                  blue:181.0/255.0
                                                 alpha:1.0];
                
                AGSSymbol *symbol = [AGSSimpleLineSymbol simpleLineSymbolWithColor:color];
                
                AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:geometry symbol:symbol attributes:nil];
                
                [_graphicLayer addGraphic:graphic];
                
                [geometries addObject:geometry];
                
            }
            
            
//            _lblResult.text = [NSString stringWithFormat:@"%.1f min (%.1f Km.)",
//                               _routeResult.totalTime, _routeResult.totalLength /1000];
            
//            _resultView.hidden = false;
            
//            [_mapView zoomToGeometry:geometry withPadding:50 animated:true];
        }
        
    }
}




- (void)unwindRouteViewController:(UIStoryboardSegue *)segue {
    
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    [_param addTravelMode:index];
}

- (void)didDeselectRowAtIndex:(NSInteger)index {
    [_param removeTravelMode:index];
}

- (void)didFinishSelectToLocation:(AGSPoint *)point {
    AGSPoint *llPoint = [AGSPoint pointFromDegreesDecimalMinutesString:[point decimalDegreesStringWithNumDigits:7]
                                                  withSpatialReference:[AGSSpatialReference wgs84SpatialReference]];
    
    _toLocation = [[NTLocation alloc] initWithName:@"location 2" lat:llPoint.y lon:llPoint.x];
    [_btnToLocation setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    [_btnToLocation setTitle:_toLocation.name forState:UIControlStateNormal];
}

- (void)didFinishSelectFromLocation:(AGSPoint *)point {
    AGSPoint *llPoint = [AGSPoint pointFromDegreesDecimalMinutesString:[point decimalDegreesStringWithNumDigits:7]
                                                  withSpatialReference:[AGSSpatialReference wgs84SpatialReference]];
    
    _fromLocation = [[NTLocation alloc] initWithName:@"location 1" lat:llPoint.y lon:llPoint.x];
    [_btnFromLocation setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    [_btnFromLocation setTitle:_fromLocation.name forState:UIControlStateNormal];
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
