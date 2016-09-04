//
//  ViewController.h
//  MapSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>
#import <ArcGIS/ArcGIS.h>

@interface MapViewController : UIViewController <AGSCalloutDelegate, AGSMapViewTouchDelegate,AGSMapViewLayerDelegate, AGSLayerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet AGSMapView *_mapView;
    __weak IBOutlet UIButton *_btnHide;
    __weak IBOutlet NSLayoutConstraint *_tableViewLeading;
    
    NTMapPermissionResultSet *_mapResult;
    
    NSArray *_lods;
    NSMutableArray *_basemaps;
    NSMutableArray *_layers;
    
    NSIndexPath *_selectedBasemap;
    NSArray *_selectedLayer;
}

@end

