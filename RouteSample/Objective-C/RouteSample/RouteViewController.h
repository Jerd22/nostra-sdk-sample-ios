//
//  RouteViewController.h
//  RouteSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <NOSTRASDK/NOSTRASDK.h>

#import "RouteMarkOnMapViewController.h"
#import "RouteDetailViewController.h"

@interface RouteViewController : UIViewController <AGSMapViewLayerDelegate, AGSLayerDelegate, MarkOnMapDelegate>
{
    
    __weak IBOutlet UIButton *_btnFromLocation;
    __weak IBOutlet UIButton *_btnToLocation;
    __weak IBOutlet AGSMapView *_mapView;
    __weak IBOutlet UIView *_resultView;
    __weak IBOutlet UILabel *_lblResult;
    
    AGSGraphicsLayer *_graphicLayer;
    
    NTRouteResult *_routeResult;
    
    NTLocation *_toLocation;
    NTLocation *_fromLocation;
    NTTravelMode _vehicle;
}
@end
