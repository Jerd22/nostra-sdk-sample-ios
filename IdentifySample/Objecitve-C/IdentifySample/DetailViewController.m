//
//  DetailViewController.m
//  IdentifySample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    
    
    NTExtraContentParameter *param = [[NTExtraContentParameter alloc] initWithNostraId:_identifyResult.nostraId];
    NTExtraContentResult *result = [NTExtraContentService execute:param error:&error];
    
    if (!error) {
        if (result.travel != nil && result.travel.count > 0) {
            NTExtraContentTravel *travel = result.travel.firstObject;
            
            _lblName.text = travel.name;
            _lblInfo.text = travel.attraction1_L;
            _lblDetail.text = travel.history_L;
            
            if (travel.picture1 != nil && ![travel.picture1 isEqualToString:@""]) {
                NSURL *url = [NSURL URLWithString:travel.picture1];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                _imageView.image = image;
            }
        }
        else if (result.food != nil && result.food.count > 0) {
            NTExtraContentFood *food = result.food.firstObject;
            
            _lblName.text = food.name;
            _lblInfo.text = food.foodType1_L;
            _lblDetail.text = food.entertainmentService_L;
            
            if (food.picture1 != nil && ![food.picture1 isEqualToString:@""]) {
                NSURL *url = [NSURL URLWithString:food.picture1];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                _imageView.image = image;
            }
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Extra content is not found."
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:true];
            }]];
            
            [self presentViewController:alertController animated:true completion:nil];
        }
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Extra content is not found."
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }]];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
    
}

@end
