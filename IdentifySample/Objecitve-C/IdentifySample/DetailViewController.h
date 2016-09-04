//
//  DetailViewController.h
//  IdentifySample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NOSTRASDK/NOSTRASDK.h>
@interface DetailViewController : UIViewController
{

    
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_lblName;
    __weak IBOutlet UILabel *_lblInfo;
    __weak IBOutlet UILabel *_lblDetail;
}

@property (nonatomic, strong) NTIdentifyResult *identifyResult;

@end
