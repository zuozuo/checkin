//
//  CtquanNearbyUsersViewController.m
//  OO
//
//  Created by apple on 12-11-15.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanNearbyUsersViewController.h"
#import "CtquanInvitation.h"
#import "CtquanScreeningViewController.h"

@interface CtquanNearbyUsersViewController ()

@end

@implementation CtquanNearbyUsersViewController

@synthesize invitationList, invitationTable;

- (void)viewDidLoad {
	CtquanUser *currentUser = [CtquanUser current];
	[currentUser signInLocation];
	if (currentUser.signInStatus) [self afterSignIn];
	else [currentUser signinFromController:self];
	invitationList = [[NSMutableArray alloc] init];
	[super viewDidLoad];
}

- (void)afterSignIn {
	[[CtquanUser current] getNearbyInvitationsFromController:self];
}

- (void)invitationGetted:(NSArray *)invites {
	invitationList = [NSMutableArray arrayWithArray:invites];
	[invitationTable reloadData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.invitationList = nil;
	self.invitationTable = nil;
	[super viewDidUnload];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [invitationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"invitationCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	CtquanInvitation *invitation = [[CtquanInvitation alloc] initWithDictionary:[invitationList objectAtIndex:indexPath.row]];
	UILabel *distance = (UILabel*)[cell viewWithTag:2];
	distance.text = [[CtquanUser current] distanceStringFromLocation:invitation.location];
	UILabel *time = (UILabel*)[cell viewWithTag:3];
	time.text = [invitation endTimeString];
	UILabel *content = (UILabel*)[cell viewWithTag:4];
	content.text = invitation.content;
	
//	UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
//	imageView.image = [UIImage imageNamed:@"avatar.png"];
	
	return cell;
}
@end
