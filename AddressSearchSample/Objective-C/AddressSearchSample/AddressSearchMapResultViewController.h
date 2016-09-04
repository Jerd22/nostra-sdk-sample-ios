//
//  AddressSearchMapResultViewController.h
//  AddressSearchSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <NOSTRASDK/NOSTRASDK.h>
@interface AddressSearchMapResultViewController : UIViewController <AGSCalloutDelegate, AGSLayerDelegate>
{
    __weak IBOutlet AGSMapView *_mapView;
    
    AGSGraphicsLayer *_graphicLayer;
}

@property (nonatomic, strong) NTAddressSearchResult *result;
@end
