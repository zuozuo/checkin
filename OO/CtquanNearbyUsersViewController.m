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

#define kAvatarTag 1
#define kNameTag 2
#define kDistanceTag 3
#define kDurationTag 4
#define kContentTag 5

@interface CtquanNearbyUsersViewController ()

@end

@implementation CtquanNearbyUsersViewController

@synthesize invitationList, invitationTable;

- (void)viewDidLoad {
	CtquanUser *currentUser = [CtquanUser current];
	[currentUser signInLocation];
	if (currentUser.signInStatus) [self afterSignIn];
//	else [currentUser signInFromController:self];
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
	UIImageView *imageView = (UIImageView*)[cell viewWithTag:kAvatarTag];
	[imageView setImageWithURL:[invitation.user thumbAvatarURL]];
	UILabel *name = (UILabel*)[cell viewWithTag:kNameTag];
	name.text = invitation.user.username;
	UILabel *distance = (UILabel*)[cell viewWithTag:kDistanceTag];
	distance.text = [[CtquanUser current] distanceStringFromLocation:invitation.location];
	UILabel *time = (UILabel*)[cell viewWithTag:kDurationTag];
	time.text = [invitation endTimeString];
	UILabel *content = (UILabel*)[cell viewWithTag:kContentTag];
	content.text = invitation.content;
//	imageView.image = [UIImage imageNamed:@"avatar.png"];
	
	return cell;
}
@end
