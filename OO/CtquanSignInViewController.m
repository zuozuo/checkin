//
//  CtquanUsersViewController.m
//  OO
//
//  Created by apple on 12-11-14.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanSignInViewController.h"
#import "CtquanUserViewController.h"

@interface CtquanSignInViewController ()

@end

@implementation CtquanSignInViewController

@synthesize emailField, passwordField, loginError;

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
	CtquanUser *currentUser = [CtquanUser current];
	[currentUser signinWith:self.emailField.text andPassword:self.passwordField.text fromController:self];
}

- (IBAction)backgroundTap:(id)sender {
	[emailField resignFirstResponder];
	[passwordField resignFirstResponder];
}

- (IBAction)textFieldEditEnd:(UITextField *)sender {
	if ([sender isEqual:emailField]) {
		[sender resignFirstResponder];
		[passwordField becomeFirstResponder];
	} else {
		[sender resignFirstResponder];
	}
}

- (void)afterSignIn {
	loginError.hidden = YES;
	[self performSegueWithIdentifier:@"loginToTabBar" sender:self];
}

- (void)failedToSignIn {
	loginError.hidden = NO;
}

- (void)viewDidUnload {
	[self setPasswordField:nil];
	[self setEmailField:nil];
	[self setLoginError:nil];
	[super viewDidUnload];
}
@end
