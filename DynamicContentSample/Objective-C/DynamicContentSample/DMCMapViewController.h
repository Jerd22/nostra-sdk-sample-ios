//
//  DMCMapViewController.h
//  DynamicContentSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <NOSTRASDK/NOSTRASDK.h>

@interface DMCMapViewController : UIViewController <AGSLayerDelegate, AGSCalloutDelegate>
{
    __weak IBOutlet AGSMapView *_mapView;
    
    AGSGraphicsLayer *_graphicLayer;
}

@property (nonatomic, strong) NTDynamicContentResult *result;

@end
