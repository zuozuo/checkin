//
//  CtquanShowBigImageViewController.m
//  OO
//
//  Created by apple on 12-11-21.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanShowBigImageViewController.h"
#import "CtquanUserInfoViewController.h"

@interface CtquanShowBigImageViewController ()

@end

@implementation CtquanShowBigImageViewController

@synthesize bigImage;

- (void)viewDidLoad {
	[bigImage setImageWithURL:[[CtquanUser current] originalAvatarURL]];
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)backgroundTap:(UIControl *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
	[self setBigImage:nil];
	[super viewDidUnload];
}
@end
