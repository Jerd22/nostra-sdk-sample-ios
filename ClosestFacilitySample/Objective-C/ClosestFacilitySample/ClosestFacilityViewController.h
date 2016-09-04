//
//  ViewController.h
//  ClosestFacilitySample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <NOSTRASDK/NOSTRASDK.h>

@interface ClosestFacilityViewController : UIViewController <AGSMapViewLayerDelegate, AGSLayerDelegate, AGSMapViewTouchDelegate>
{
    __weak IBOutlet AGSMapView *_mapView;
    AGSGraphicsLayer *_graphicLayer;
    AGSGraphicsLayer *_facilityLayer;
    
    NTLocation *_facility1;
    NTLocation *_facility2;
    NTLocation *_facility3;
    NTLocation *_facility4;
}

@end

