//
//  DMCDetailViewController.m
//  DynamicContentSample
//
//  Copyright © 2559 Globtech. All rights reserved.
//

#import "DMCDetailViewController.h"

@interface DMCDetailViewController ()

@end

@implementation DMCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lblName.text = _result.name_L;
    _lblAddress.text = _result.address_L;
    _lblDetail.text = _result.detail_L;
    _lblTelNo.text = _result.telNo;
    _lblAddInfo.text = _result.addInfo_L;
    _lblWebsite.text = _result.website;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detailtoMapSegue"]) {
        DMCMapViewController *mapViewController = segue.destinationViewController;
        mapViewController.result = _result;
    }
}

- (IBAction)btnShare_Clicked:(id)sender {
    NTLocation *location = [[NTLocation alloc] initWithName:_result.name_L
                                                        lat:_result.lat
                                                        lon:_result.lon];
    NSError *error = nil;
    NTShortLinkParameter *param = [[NTShortLinkParameter alloc] initWithStops:@[location]];
    
    NTShortLinkResult *shareResult = [NTShortLinkService execute:param error:&error];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Share" message:shareResult.result preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Copy"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [[UIPasteboard generalPasteboard] setString:shareResult.result];
                                                      }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];

}

@end
