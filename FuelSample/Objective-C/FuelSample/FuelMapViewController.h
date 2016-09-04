//
//  FuelMapViewController.h
//  FuelSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <NOSTRASDK/NOSTRASDK.h>

#import "FuelResultVenderViewController.h"

@interface FuelMapViewController : UIViewController <AGSLayerDelegate, AGSMapViewLayerDelegate>
{
    __weak IBOutlet AGSMapView *_mapView;
    
}
@end
