//
//  CtquanUsersViewController.h
//  OO
//
//  Created by apple on 12-11-14.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CtquanSignInViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UILabel *loginError;

- (void)afterSignIn;
- (void)failedToSignIn;
	
@end
