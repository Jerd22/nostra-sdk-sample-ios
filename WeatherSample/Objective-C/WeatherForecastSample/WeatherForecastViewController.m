//
//  WeatherForecastViewController.m
//  WeatherForecastSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "WeatherForecastViewController.h"

#define REFERRER @""

@interface WeatherForecastViewController ()

@end

@implementation WeatherForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initializeMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)mapView:(AGSMapView *)mapView didTapAndHoldAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint features:(NSDictionary *)features {
    if (_graphicLayer.graphicsCount > 0) {
        [_graphicLayer removeAllGraphics];
    }
    
    AGSSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImageNamed:@"pin_map"];
    AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:mappoint symbol:symbol attributes:nil];
    
    [_graphicLayer addGraphic:graphic];
    
    [mapView.callout showCalloutAtPoint:mappoint forFeature:graphic layer:_graphicLayer animated:true];
}

- (BOOL)callout:(AGSCallout *)callout willShowForFeature:(id<AGSFeature>)feature layer:(AGSLayer<AGSHitTestable> *)layer mapPoint:(AGSPoint *)mapPoint {
    
    
    NSError *error = nil;
    AGSPoint *point = [AGSPoint pointFromDecimalDegreesString:[mapPoint decimalDegreesStringWithNumDigits:7]
                                         withSpatialReference:[AGSSpatialReference wgs84SpatialReference]];
    
    NTWeatherParameter *param = [[NTWeatherParameter alloc] initWithLat:point.y
                                                                    lon:point.x
                                                              frequency:NTWeatherFrequencyDaily];
    
    NTWeatherResult *result = [NTWeatherService execute:param error:&error];
    
    
    
    if (!error) {
        NTWeather *weather = result.weather.firstObject;
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:weather.icon]]];
        
        callout.image = image;
        callout.accessoryButtonHidden = true;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd MMM hh:mm";
        _lblDesc.text = weather.desc;
        _lblAvgTemp.text = [NSString stringWithFormat:@"%.1f˚", weather.temperature.avg];
        _lblMinTemp.text = [NSString stringWithFormat:@"%.1f˚", weather.temperature.min];
        _lblMaxTemp.text = [NSString stringWithFormat:@"%.1f˚", weather.temperature.max];
        _lblLocation.text = _weatherResult.locationName;
        _lblDateTime.text = [formatter stringFromDate:weather.timeStamp];
        _weatherView.hidden = false;
        return true;
    }
    else {
        NSLog(@"%@", error.localizedDescription);
        _weatherView.hidden = true;
        return false;
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
