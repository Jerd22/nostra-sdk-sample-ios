//
//  ViewController.h
//  IdentifySample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <NOSTRASDK/NOSTRASDK.h>
#import <CoreLocation/CoreLocation.h>
#import "DetailViewController.h"

@interface IdentifyViewController : UIViewController <AGSMapViewLayerDelegate, AGSMapViewTouchDelegate, AGSCalloutDelegate, AGSLayerDelegate>
{
    
    __weak IBOutlet AGSMapView *_mapView;
    AGSGraphicsLayer *_graphicLayer;
    NTIdentifyResult *_identifyResult;
}

@end

