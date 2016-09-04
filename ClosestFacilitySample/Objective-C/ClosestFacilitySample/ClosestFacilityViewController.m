//
//  ViewController.m
//  ClosestFacilitySample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "ClosestFacilityViewController.h"

#define REFERRER @""

@interface ClosestFacilityViewController ()

@end

@implementation ClosestFacilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initializeMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint features:(NSDictionary *)features {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Pin Location"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [_facilityLayer removeAllGraphics];
                                                          AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:mappoint
                                                                                                         symbol:[AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"pin_map"]
                                                                                                     attributes:nil];
                                                          [_facilityLayer addGraphic:graphic];
                                                          
                                                          AGSPoint *point = [AGSPoint pointFromDecimalDegreesString:[mappoint decimalDegreesStringWithNumDigits:7]
                                                                                               withSpatialReference:[AGSSpatialReference wgs84SpatialReference]];
                                                          NTLocation *incident = [[NTLocation alloc] initWithName:@"incident" lat:point.y lon:point.x];
                                                          
                                                          NSArray *facilities = @[_facility1, _facility2, _facility3, _facility4];
                                                          
                                                          NTClosestFacilityParameter *param = [[NTClosestFacilityParameter alloc] initWithFacilities:facilities
                                                                                                                                            incident:@[incident]];
                                                          
                                                          NSError *error = nil;
                                                          NTClosestFacilityResultSet *resultSet = [NTClosestFacilityService execute:param error:&error];
                                                          
                                                          if (!error) {
                                                              
                                                              AGSSymbol *symbol = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor grayColor] width:4];
                                                              
                                                              for (NTClosestFacilityResult *result in resultSet.closestFacilities) {
                                                                  AGSPolyline *line = [[AGSPolyline alloc] initWithJSON:[result getShape]
                                                                                                       spatialReference:[AGSSpatialReference wgs84SpatialReference]];
                                                                  AGSGeometry *geometry = [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:line
                                                                                                                                  toSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
                                                                  
                                                                  AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:geometry symbol:symbol attributes:nil];
                                                                  
                                                                  [_facilityLayer addGraphic:graphic];
                                                                  
                                                              }
                                                              
                                                          }
                                                          
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
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
    _facilityLayer = [[AGSGraphicsLayer alloc] init];
    
    [mapView addMapLayer:_facilityLayer];
    [mapView addMapLayer:_graphicLayer];

    _facility1 = [[NTLocation alloc] initWithName:@"MBK"
                                              lat:13.744651781616076
                                              lon:100.53145034771327];
    _facility2 = [[NTLocation alloc] initWithName:@"SiamDis"
                                              lat:13.746598089591219
                                              lon:100.53145034771327];
    _facility3 = [[NTLocation alloc] initWithName:@"SiamCenter"
                                              lat:13.746321783330115
                                              lon:100.53279034433699];
    _facility4 = [[NTLocation alloc] initWithName:@"SiamParagon"
                                              lat:13.746155248206387
                                              lon:100.53481456769379];
    
    AGSPoint *facilityPoint1 = [AGSPoint pointWithX:_facility1.lon
                                                 y:_facility1.lat
                                  spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    AGSPoint *facilityPoint2 = [AGSPoint pointWithX:_facility2.lon
                                                 y:_facility2.lat
                                  spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    AGSPoint *facilityPoint3 = [AGSPoint pointWithX:_facility3.lon
                                                 y:_facility3.lat
                                  spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    AGSPoint *facilityPoint4 = [AGSPoint pointWithX:_facility4.lon
                                                 y:_facility4.lat
                                  spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    
    AGSPoint *facilityMappoint1 = [AGSPoint pointFromDecimalDegreesString:[facilityPoint1 decimalDegreesStringWithNumDigits:7]
                                                     withSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    AGSPoint *facilityMappoint2 = [AGSPoint pointFromDecimalDegreesString:[facilityPoint2 decimalDegreesStringWithNumDigits:7]
                                                     withSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    AGSPoint *facilityMappoint3 = [AGSPoint pointFromDecimalDegreesString:[facilityPoint3 decimalDegreesStringWithNumDigits:7]
                                                     withSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    AGSPoint *facilityMappoint4 = [AGSPoint pointFromDecimalDegreesString:[facilityPoint4 decimalDegreesStringWithNumDigits:7]
                                                     withSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    AGSCompositeSymbol *compSymbol = [[AGSCompositeSymbol alloc] init];
    
    AGSSimpleMarkerSymbol *marker = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor whiteColor]];
    marker.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor blackColor]];
    marker.size = CGSizeMake(30, 30);
    AGSTextSymbol *textSymbol = [AGSTextSymbol textSymbolWithText:@"1" color:[UIColor blackColor]];
    
    [compSymbol addSymbols:@[marker, textSymbol]];
    
    AGSGraphicsLayer *graphic1 = [AGSGraphic graphicWithGeometry:facilityMappoint1 symbol:compSymbol attributes:nil];
    textSymbol.text = @"2";
    AGSGraphicsLayer *graphic2 = [AGSGraphic graphicWithGeometry:facilityMappoint2 symbol:compSymbol attributes:nil];
    textSymbol.text = @"3";
    AGSGraphicsLayer *graphic3 = [AGSGraphic graphicWithGeometry:facilityMappoint3 symbol:compSymbol attributes:nil];
    textSymbol.text = @"4";
    AGSGraphicsLayer *graphic4 = [AGSGraphic graphicWithGeometry:facilityMappoint4 symbol:compSymbol attributes:nil];

    
    [_graphicLayer addGraphics:@[graphic1, graphic2, graphic3, graphic4]];
    
    AGSGeometry *allFacilityEnvelope = [[AGSGeometryEngine defaultGeometryEngine] unionGeometries:@[facilityMappoint1, facilityMappoint2, facilityMappoint3, facilityMappoint4]];
    [_mapView zoomToGeometry:allFacilityEnvelope withPadding:100 animated:true];

    
}



- (void)initializeMap {
    _mapView.layerDelegate = self;
    _mapView.touchDelegate = self;
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
