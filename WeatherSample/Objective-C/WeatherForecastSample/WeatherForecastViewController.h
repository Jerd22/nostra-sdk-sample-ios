//
//  WeatherForecastViewController.h
//  WeatherForecastSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <NOSTRASDK/NOSTRASDK.h>

@interface WeatherForecastViewController : UIViewController <AGSMapViewLayerDelegate, AGSMapViewTouchDelegate, AGSCalloutDelegate, AGSLayerDelegate>
{
    __weak IBOutlet UIView *_weatherView;
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_lblDesc;
    __weak IBOutlet UILabel *_lblMaxTemp;
    __weak IBOutlet UILabel *_lblAvgTemp;
    __weak IBOutlet UILabel *_lblLocation;
    __weak IBOutlet UILabel *_lblDateTime;
    __weak IBOutlet UILabel *_lblMinTemp;
    __weak IBOutlet AGSMapView *_mapView;
    
    AGSGraphicsLayer *_graphicLayer;
    NTWeatherResult *_weatherResult;
    
    
}

@end

