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

@synthesize text, type, textField;

- (void)viewDidLoad {
	[textField becomeFirstResponder];
	textField.text = text;
	[super viewDidLoad];
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
	NSDictionary *params = [NSDictionary dictionaryWithObject:textField.text forKey:type];
	if ([textField.text isEqualToString:text]) [self afterUpdated];
	else [[CtquanUser current] updateWith:params FromController:self];
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
