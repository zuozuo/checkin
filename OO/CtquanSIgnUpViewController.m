//
//  CtquanSIgnUpViewController.m
//  OO
//
//  Created by apple on 12-11-20.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanSignUpViewController.h"

@interface CtquanSignUpViewController ()

@end

@implementation CtquanSignUpViewController

@synthesize emailField, passwordField, usernameField, confirmField;

- (IBAction)textFieldEditEnd:(UITextField *)sender {
	NSInteger tag = sender.tag;
	[sender resignFirstResponder];
	if (tag < 4)
		[[self.view viewWithTag:(tag +1)] becomeFirstResponder];
}

- (IBAction)backgroundTap:(UIControl *)sender {
	for (UIView *view in [sender subviews]) {
    if ([view isFirstResponder])
			[view resignFirstResponder];
	}
}

- (IBAction)signUpButtonPressed:(UIButton *)sender {
	CtquanUser *currentUser = [[CtquanUser current]
														 initWithDictionary: [NSDictionary dictionaryWithObjectsAndKeys:
																									emailField.text, @"email",
																									usernameField.text, @"username",
																									passwordField.text, @"password", nil]];
	[currentUser signUpFromController:self];
}

- (void)afterSignUp {
	NSLog(@"after sign up%@", [CtquanUser current]);
	[self performSegueWithIdentifier:@"signUpToTabBar" sender:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}
@end
