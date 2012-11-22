//
//  CtquanInvitationViewController.h
//  OO
//
//  Created by apple on 12-11-16.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface CtquanInvitationViewController : UIViewController <BMKSearchDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textField;
@property (strong, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) BMKSearch *search;
@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *latitude;
@property (strong, nonatomic) IBOutlet UILabel *longitude;

@end
