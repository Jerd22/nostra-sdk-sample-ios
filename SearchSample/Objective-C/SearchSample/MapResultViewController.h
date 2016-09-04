//
//  MapResultViewController.h
//  SearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>
#import <ArcGIS/ArcGIS.h>

@interface MapResultViewController : UIViewController <AGSLayerDelegate, AGSMapViewLayerDelegate, AGSCalloutDelegate>
{
    __weak IBOutlet AGSMapView *_mapView;
    
    AGSGraphicsLayer *_graphicLayer;
}
@property (nonatomic, strong) NTLocationSearchResult *result;
@end
