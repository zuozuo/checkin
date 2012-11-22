//
//  CtquanInvitationViewController.m
//  OO
//
//  Created by apple on 12-11-16.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanInvitationViewController.h"
#import "CtquanNearbyUsersViewController.h"

@interface CtquanInvitationViewController ()

@end

@implementation CtquanInvitationViewController

@synthesize search, mapView, duration, textField, errorMessageLabel;
@synthesize latitude, longitude;

- (void)viewDidLoad {
	[super viewDidLoad];
	mapView.delegate = (id)self;
	search = [[BMKSearch alloc] init];
	search.delegate = self;
	[search reverseGeocode:[CtquanUser current].location.coordinate];
	
	CtquanUser *u = [CtquanUser current];
	latitude.text = [NSString stringWithFormat:@"%f", u.location.coordinate.latitude];
	longitude.text = [NSString stringWithFormat:@"%f", u.location.coordinate.longitude];
	
	UIButton *button = (UIButton *)[self.view viewWithTag:1];
	button.backgroundColor = [UIColor blueColor];
	duration = [NSNumber numberWithFloat:0.5];
	UIScrollView *tempScrollView=(UIScrollView *)self.view;
	tempScrollView.contentSize=CGSizeMake(320,640);
}

- (IBAction)sendButtonPressed:(UIButton *)sender {
	if (textField.text.length == 0) {
		errorMessageLabel.hidden = NO;
	} else {
		CtquanNearbyUsersViewController *nearby = [self.navigationController.viewControllers objectAtIndex:0];
		[[CtquanUser current] sendInvitationWithContent:textField.text andDuration:duration FromController:nearby];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (IBAction)durationButtonPressed:(UIButton *)sender {
	for (UIView *view in [[self.view viewWithTag:100] subviews])
		if ([view isMemberOfClass:[sender class]])
			[view performSelector:@selector(setBackgroundColor:) withObject:[UIColor whiteColor]];
	sender.backgroundColor = [UIColor blueColor];
	duration = [NSNumber numberWithFloat:((float)sender.tag)/2];
}

- (IBAction)backgroundTap:(UIControl *)sender {
	[textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[self setTextField:nil];
	[self setErrorMessageLabel:nil];
	[self setLatitude:nil];
	[self setLongitude:nil];
	[super viewDidUnload];
}

#pragma mark -
#pragma mark BMKSearchDelegate methods
- (void)onGetAddrResult:(BMKAddrInfo *)result errorCode:(int)error {
	NSLog(@"%@", result);
	NSLog(@"poi---------------%@", result.poiList);
	NSLog(@"adr---------------%@", result.strAddr);
	NSLog(@"com---------------%@", result.addressComponent.city);
}
@end




























