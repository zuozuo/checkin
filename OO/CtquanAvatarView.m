//
//  CtquanAvatarView.m
//  OO
//
//  Created by apple on 12-11-21.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanAvatarView.h"
#import "CtquanUserInfoViewController.h"

@implementation CtquanAvatarView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CtquanStoryBoard *sb = [CtquanStoryBoard main];
	UIViewController *imageController = [sb instantiateViewControllerWithIdentifier:@"showBigImage"];
	CtquanUserInfoViewController *userController = [sb instantiateViewControllerWithIdentifier:@"userInfoView"];
	[userController presentModalViewController:imageController animated:YES];
}

@end
