//
//  CtquanUserInfoEditViewController.m
//  OO
//
//  Created by apple on 12-11-20.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanUserInfoEditViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AFHTTPRequestOperation.h"

#define kPhotoLibraryButtonIndex 0
#define kCameraButtonIndex 1

@interface CtquanUserInfoEditViewController ()
@end

@implementation CtquanUserInfoEditViewController

@synthesize textField;

- (void)viewDidLoad {
	[textField becomeFirstResponder];
	CtquanUser *currentUser = [CtquanUser current];
	if (textField.tag == 1) textField.text = currentUser.name;
	else textField.text = currentUser.username;
		
	[super viewDidLoad];
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
	NSString *type;
	if (sender.tag == 1) type = @"name";
	else type = @"username";
	NSString *key = [NSString stringWithFormat:@"user[%@]", type];
	NSDictionary *params = [NSDictionary dictionaryWithObject:textField.text forKey:key];
	[[CtquanUser current] updateWith:params FromController:self];
}

- (void)afterUpdated {
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[self setTextField:nil];
	[super viewDidUnload];
}
@end
