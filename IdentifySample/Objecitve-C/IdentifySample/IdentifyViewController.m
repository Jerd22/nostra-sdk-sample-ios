//
//  ViewController.m
//  IdentifySample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "IdentifyViewController.h"
#import <ArcGIS/ArcGIS.h>
#import <NOSTRASDK/NOSTRASDK.h>

#define REFERRER @""

@interface IdentifyViewController ()

@end

@implementation IdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initializeMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.identifyResult = _identifyResult;
    }
}

- (IBAction)btnCurrentLocation_Clicked:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    _mapView.locationDisplay.autoPanMode = btn.selected ? AGSLocationDisplayAutoPanModeDefault : AGSLocationDisplayAutoPanModeOff;
}

- (void)mapView:(AGSMapView *)mapView didTapAndHoldAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint features:(NSDictionary *)features {
    
    if (_graphicLayer.graphicsCount > 0) {
        [_graphicLayer removeAllGraphics];
    }
    
    AGSSimpleMarkerSymbol *symbol = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor redColor]];
    symbol.style = AGSSimpleMarkerSymbolStyleX;
    symbol.size = CGSizeMake(15, 15);
    
    AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:mappoint symbol:symbol attributes:nil];
    
    [_graphicLayer addGraphic:graphic];

}


- (BOOL)callout:(AGSCallout *)callout willShowForFeature:(id<AGSFeature>)feature layer:(AGSLayer<AGSHitTestable> *)layer mapPoint:(AGSPoint *)mapPoint {
    BOOL show = false;
    
    NSError *error = nil;
    
    AGSPoint *llpoint = [AGSPoint pointFromDecimalDegreesString:[mapPoint decimalDegreesStringWithNumDigits:7]
                                           withSpatialReference:[AGSSpatialReference wgs84SpatialReference]];
    NTIdentifyParameter *param = [[NTIdentifyParameter alloc] initWithLat:llpoint.y
                                                                      lon:llpoint.x];
    
    _identifyResult = [NTIdentifyService execute:param error:&error];
    
    if (!error) {
        callout.title = _identifyResult.name_L;
        callout.detail = [NSString stringWithFormat:@"%@, %@, %@", _identifyResult.adminLevel3_L, _identifyResult.adminLevel2_L, _identifyResult.adminLevel1_L];
        
        if (_identifyResult.nostraId != nil && ![_identifyResult.nostraId isEqualToString:@""]) {
            callout.accessoryButtonHidden = false;
        }
        else {
            callout.accessoryButtonHidden = true;
        }
        
        show = true;
    }
    

    return show;
}

- (void)didClickAccessoryButtonForCallout:(AGSCallout *)callout {
    [self performSegueWithIdentifier:@"detailSegue" sender:nil];
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
    _mapView.touchDelegate = self;
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
