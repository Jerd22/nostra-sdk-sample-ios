//
//  ViewController.h
//  ServiceAreaSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <NOSTRASDK/NOSTRASDK.h>

@interface ServiceAreaViewController : UIViewController <AGSMapViewLayerDelegate, AGSMapViewTouchDelegate>
{
    
    __weak IBOutlet AGSMapView *_mapView;
    
    AGSGraphicsLayer *_graphicLayer;
    AGSGraphicsLayer *_serviceAreaLayer;
}

@end

