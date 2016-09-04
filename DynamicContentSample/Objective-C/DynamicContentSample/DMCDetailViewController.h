//
//  DMCDetailViewController.h
//  DynamicContentSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>
#import "DMCMapViewController.h"
@interface DMCDetailViewController : UIViewController
{
    
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_lblName;
    __weak IBOutlet UILabel *_lblAddress;
    __weak IBOutlet UILabel *_lblDetail;
    __weak IBOutlet UILabel *_lblTelNo;
    __weak IBOutlet UILabel *_lblAddInfo;
    __weak IBOutlet UILabel *_lblWebsite;
}

@property (nonatomic, strong) NTDynamicContentResult *result;

@end
