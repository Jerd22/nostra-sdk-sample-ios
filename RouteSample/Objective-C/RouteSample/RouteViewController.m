//
//  RouteViewController.m
//  RouteSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "RouteViewController.h"

#define REFERRER @""

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMap];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fromLocationSegue"] || [segue.identifier isEqualToString:@"toLocationSegue"]) {
        RouteMarkOnMapViewController *routeMarkOnMapViewController = segue.destinationViewController;
        routeMarkOnMapViewController.delegate = self;
        routeMarkOnMapViewController.isFromLocation = [segue.identifier isEqualToString:@"fromLocationSegue"];
    }
    else if ([segue.identifier isEqualToString:@"routeDetailSegue"]) {
        RouteDetailViewController *routeDetailViewCotroller = segue.destinationViewController;
        routeDetailViewCotroller.directions = _routeResult.directions;
    }
    
}

- (IBAction)btnSelectVehicle_Clicked:(id)sender {
    
    
    UIButton *btn = sender;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Vehicle"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Car"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          _vehicle = NTTravelModeCar;
                                                          [btn setTitle:@"Car" forState:UIControlStateNormal];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Motorcycle"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          _vehicle = NTTravelModeMotorCycle;
                                                          [btn setTitle:@"Motorcycle" forState:UIControlStateNormal];
                                                      }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Bike"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          _vehicle = NTTravelModeBicycle;
                                                          [btn setTitle:@"Bike" forState:UIControlStateNormal];
                                                      }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Walk"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          _vehicle = NTTravelModeWalk;
                                                          [btn setTitle:@"Walk" forState:UIControlStateNormal];
                                                      }]];
    
    [self presentViewController:alertController animated:true completion:nil];
    
}
- (IBAction)btnCalculateRoute_Clicked:(id)sender {
    
    if (_toLocation != nil && _fromLocation != nil) {
        NSError *error = nil;
        
        NTRouteParameter *param = [[NTRouteParameter alloc] initWithStops:@[_fromLocation, _toLocation]];
        param.travelMode = _vehicle;
        
        _routeResult = [NTRouteService execute:param error:&error];
        
        if (!error)
        {
            AGSPolyline *line = [[AGSPolyline alloc] initWithJSON:[_routeResult getShape] spatialReference:[AGSSpatialReference wgs84SpatialReference]];
            AGSGeometry *geometry = [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:line
                                                                            toSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
            
            UIColor *color = [UIColor colorWithRed:63.0/255.0
                                             green:81.0/255.0
                                              blue:181.0/255.0
                                             alpha:1.0];
            
            AGSSymbol *symbol = [AGSSimpleLineSymbol simpleLineSymbolWithColor:color
                                                                         width:10.0f];
            
            AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:geometry symbol:symbol attributes:nil];
            
            [_graphicLayer addGraphic:graphic];
            
            _lblResult.text = [NSString stringWithFormat:@"%.1f min (%.1f Km.)",
                               _routeResult.totalTime, _routeResult.totalLength /1000];
            
            _resultView.hidden = false;
            
            [_mapView zoomToGeometry:geometry withPadding:50 animated:true];
        }

    }
}

- (IBAction)unwindRouteViewController:(UIStoryboardSegue *)unwindSegue
{
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
