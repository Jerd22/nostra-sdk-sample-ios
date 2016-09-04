//
//  ViewController.m
//  ServiceAreaSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "ServiceAreaViewController.h"
#define REFERRER @""

@interface ServiceAreaViewController ()

@end

@implementation ServiceAreaViewController

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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Pin Location"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [_graphicLayer removeAllGraphics];
                                                         [_serviceAreaLayer removeAllGraphics];
                                                         AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:mappoint
                                                                                                        symbol:[AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"pin_map"]
                                                                                                    attributes:nil];
                                                         
                                                         [_graphicLayer addGraphic:graphic];
                                                         
                                                         AGSPoint *point = [AGSPoint pointFromDecimalDegreesString:[mappoint decimalDegreesStringWithNumDigits:7]
                                                                                              withSpatialReference:[AGSSpatialReference wgs84SpatialReference]];
                                                         
                                                         NTLocation *location = [[NTLocation alloc] initWithName:@"facility" lat:point.y lon:point.x];
                                                         
                                                         NSError *error = nil;
                                                         
                                                         NTServiceAreaParameter *param = [[NTServiceAreaParameter alloc] initWithFacilities:@[location]
                                                                                                                                     breaks:@[@1,@3,@5]];
                                                                                          
                                                
                                                         NTServiceAreaResultSet *resultSet = [NTServiceAreaService execute:param error:&error];
                                                                                          
                                                         
                                                         if (!error && resultSet.results.count == 3) {
                                                                                              
                                                             
                                                             NTServiceAreaResult *result = resultSet.results[2];
                                                             
                                                             AGSPolygon *polygon = [[AGSPolygon alloc] initWithJSON:[result getShape] spatialReference:[AGSSpatialReference wgs84SpatialReference]];
                                                             
                                                             AGSGeometry *geometry = [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:polygon toSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
                                                                                              
                                                             
                                                             AGSSimpleFillSymbol *fillSymbol = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor redColor] outlineColor:[UIColor redColor]];
                                                                                              
                                                             
                                                             AGSGraphic *grpahic = [AGSGraphic graphicWithGeometry:geometry symbol:fillSymbol attributes:nil];
                                                                                              
                                                             
                                                             [_serviceAreaLayer addGraphic:graphic];
                                                                                              
                                                             
                                                             result = resultSet.results[1];
                                                             
                                                             polygon = [[AGSPolygon alloc] initWithJSON:[result getShape] spatialReference:[AGSSpatialReference wgs84SpatialReference]];
                                                             
                                                             geometry = [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:polygon toSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
                                                                                              
                                                             
                                                             fillSymbol = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor yellowColor] outlineColor:[UIColor yellowColor]];
                                                                                              
                                                             
                                                             grpahic = [AGSGraphic graphicWithGeometry:geometry symbol:fillSymbol attributes:nil];
                                                                                              
                                                             
                                                             [_serviceAreaLayer addGraphic:graphic];
                                                                                              
                                                             
                                                             result = resultSet.results[0];
                                                             
                                                             polygon = [[AGSPolygon alloc] initWithJSON:[result getShape] spatialReference:[AGSSpatialReference wgs84SpatialReference]];
                                                             
                                                             geometry = [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:polygon toSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
                                                                                              
                                                             
                                                             fillSymbol = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor greenColor] outlineColor:[UIColor greenColor]];
                                                                                              
                                                             
                                                             grpahic = [AGSGraphic graphicWithGeometry:geometry symbol:fillSymbol attributes:nil];
                                                                                              
                                                             
                                                             [_serviceAreaLayer addGraphic:graphic];
                                                                                              
                                                             
                                                             [_mapView zoomToGeometry:geometry withPadding:100 animated:true];
                                                             
                                                         }
                                                                                          
                                                         
                                                     }];
    
    [alertController addAction:okAction];
    
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
    _serviceAreaLayer = [[AGSGraphicsLayer alloc] init];
    
    [mapView addMapLayer:_serviceAreaLayer withName:@"ServiceGraphicLayer"];
    [mapView addMapLayer:_graphicLayer withName:@"GraphicLayer"];
    
    
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
