//
//  MultiModalMainViewController.h
//  MultiModalSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <NOSTRASDK/NOSTRASDK.h>

#import "TravelByViewController.h"
#import "MarkOnMapViewController.h"

@interface MultiModalMainViewController : UIViewController <AGSMapViewLayerDelegate, AGSLayerDelegate, MarkOnMapDelegate, TravelByViewControllerDelegate>
{
    
    __weak IBOutlet UIButton *_btnFromLocation;
    __weak IBOutlet UIButton *_btnToLocation;
    __weak IBOutlet AGSMapView *_mapView;
    
    AGSGraphicsLayer *_graphicLayer;
    
    NTMultiModalResult *_result;
    
    NTLocation *_toLocation;
    NTLocation *_fromLocation;
    
    NTMultiModalTransportParamter *_param;
    
}
@end
