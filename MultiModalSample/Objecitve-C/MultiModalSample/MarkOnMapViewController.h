//
//  MarkOnMapViewController.h
//  MultiModalSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <NOSTRASDK/NOSTRASDK.h>

@protocol MarkOnMapDelegate <NSObject>

- (void)didFinishSelectFromLocation:(AGSPoint *)point;
- (void)didFinishSelectToLocation:(AGSPoint *)point;

@end

@interface MarkOnMapViewController : UIViewController <AGSMapViewLayerDelegate, AGSLayerDelegate> {
    
    __weak IBOutlet AGSMapView *_mapView;
}


@property (nonatomic, strong) id<MarkOnMapDelegate> delegate;
@property (nonatomic, readwrite) BOOL isFromLocation;
@end
