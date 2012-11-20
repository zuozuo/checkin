//
//  CtquanScreeningViewController.m
//  OO
//
//  Created by apple on 12-11-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanScreeningViewController.h"
#import "CtquanNearbyUsersViewController.h"

@interface CtquanScreeningViewController ()

@end

@implementation CtquanScreeningViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	CtquanUser *currentUser = [CtquanUser current];
	NSNumber *duration = [NSNumber numberWithFloat:[currentUser.duration floatValue]*2];
	NSNumber *distance = [NSNumber numberWithFloat:([currentUser.distance floatValue]*2+10)];
	UIButton *distanceButton = (UIButton *)[self.view viewWithTag:[distance integerValue]];
	UIButton *durationButton = (UIButton *)[self.view viewWithTag:[duration integerValue]];
	durationButton.backgroundColor = [UIColor blueColor];
	distanceButton.backgroundColor = [UIColor blueColor];
}

- (IBAction)confirmButtonPressed:(UIButton *)sender {
	[[CtquanUser current] sendDistanceAndDuration];
	CtquanNearbyUsersViewController *nearby = [self.navigationController.viewControllers objectAtIndex:0];
	[nearby afterSignIn];
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)distanceButtonPressed:(UIButton *)sender {
	for (UIView *view in [self.view subviews])
		if ([view isMemberOfClass:[sender class]]) {
			NSInteger bigger = view.tag > sender.tag	? view.tag : sender.tag;
			NSInteger	smaller = view.tag < sender.tag	? view.tag : sender.tag;
			if ((bigger - smaller) < 5) {
				[view performSelector:@selector(setBackgroundColor:) withObject:[UIColor whiteColor]];
			}
		}
	sender.backgroundColor = [UIColor blueColor];
	CtquanUser *currentUser = [CtquanUser current];
	if (sender.tag > 10) {
		currentUser.distance = [NSNumber numberWithFloat:((float)(sender.tag-10))/2];
	} else {
		currentUser.duration = [NSNumber numberWithFloat:((float)sender.tag)/2];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
