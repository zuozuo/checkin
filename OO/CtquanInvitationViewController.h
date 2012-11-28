//
//  CtquanInvitationViewController.h
//  OO
//
//  Created by apple on 12-11-16.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CtquanInvitationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *textField;
@property (strong, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (strong, nonatomic) NSNumber *duration;

@end
