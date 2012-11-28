//
//  CtquanNearbyUsersViewController.m
//  OO
//
//  Created by apple on 12-11-15.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CtquanNearbyUsersViewController.h"
#import "CtquanInvitation.h"
#import "CtquanScreeningViewController.h"
#import "BMKMapView+Location.h"

#define kAvatarTag 1
#define kNameTag 2
#define kDistanceTag 3
#define kDurationTag 4
#define kContentTag 5

#define REFRESH_HEADER_HEIGHT 44.0f

#define kPullTextKey @"下拉刷新"
#define kReleaseTextKey @"松开刷新"
#define kLoadingKey @"正在加载..."
#define kLocateKey @"正在定位..."

@interface CtquanNearbyUsersViewController ()

@end

@implementation CtquanNearbyUsersViewController

@synthesize invitationList, invitationTable, refreshArrow, refreshHeaderView,
	refreshLabel, isDragging, isLoading, refreshSpinner, moreView, moreSpinner,
	moreButton, isGettingMore, displayNumber;

- (IBAction)moreButtonPressed:(UIButton *)sender {
	if (isGettingMore) return;
	isGettingMore = YES;
	displayNumber += 20;
	[moreButton setBackgroundColor: [UIColor grayColor]];
	[moreButton setTitle:kLoadingKey forState:UIControlStateNormal];
	[moreSpinner startAnimating];
	[[CtquanUser current] getNearbyInvitationsFromController:self];
}

- (NSNumber *)invitationsNumber {
	return [NSNumber numberWithInteger:(displayNumber ? displayNumber : 20)];
}

- (void)startLoading {
	isLoading = YES;
	displayNumber = 20;
	[UIView animateWithDuration:0.3 animations:^{
		invitationTable.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
		[self setLoadingHeader];
	}];
	[self refresh];
}

- (void)setLoadingHeader {
	refreshLabel.text = kLoadingKey;
	refreshArrow.hidden = YES;
	[refreshSpinner startAnimating];
}

- (void)refresh {
	[self getUserLocation];
}

- (void)stopLoading {
	isLoading = NO;
	refreshHeaderView.frame = CGRectMake(0, 0-REFRESH_HEADER_HEIGHT, 320.0, 44.0);
	[UIView animateWithDuration:0.3
									 animations:^{
										 self.invitationTable.contentInset = UIEdgeInsetsZero;
											 [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
										 } completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
	refreshLabel.text = kPullTextKey;
	refreshArrow.hidden = NO;
	[refreshSpinner stopAnimating];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[[BMKMapView share] setShowsUserLocation:YES];
	
	[self addMoreSpinnerToMoreView];
	
	CtquanUser *currentUser = [CtquanUser current];
	if (currentUser.signInStatus) [self performSelectorInBackground:@selector(getUserLocation) withObject:nil];
	invitationList = [[NSMutableArray alloc] init];
	[self addPullToRefreshHeader];
	refreshHeaderView.frame = CGRectMake(0, 0, 32.0, 44.0);
	refreshLabel.text = kLocateKey;
	refreshArrow.hidden = YES;
	[refreshSpinner startAnimating];
}

- (void)addPullToRefreshHeader {
	refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
	refreshHeaderView.backgroundColor = [UIColor clearColor];
	
	refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
	refreshLabel.backgroundColor = [UIColor clearColor];
	refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
	refreshLabel.textAlignment = UITextAlignmentCenter;
	
	refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
	refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
																	(floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
																	27, 44);
	
	refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
	refreshSpinner.hidesWhenStopped = YES;
	
	[refreshHeaderView addSubview:refreshLabel];
	[refreshHeaderView addSubview:refreshArrow];
	[refreshHeaderView addSubview:refreshSpinner];
	[self.invitationTable addSubview:refreshHeaderView];
}

- (void)addMoreSpinnerToMoreView {
	moreSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	moreSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2 + 95), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
	moreSpinner.hidesWhenStopped = YES;
	[moreView addSubview:moreSpinner];
}

- (void)getUserLocation {
	[[BMKMapView share] getLocationInSeconds:10
													begin:^{
														refreshLabel.text = kLoadingKey;
													} success:^{
														[[CtquanUser current] getNearbyInvitationsFromController:self];
														[self setLoadingHeader];
													} failure:nil];
}

- (void)afterSignIn {
	[[CtquanUser current] getNearbyInvitationsFromController:self];
}

- (void)invitationGetted:(NSArray *)invites {
	if ([[self invitationsNumber] integerValue] == 20) displayNumber = 40;
	BOOL noMore = (invites.count == invitationList.count);
	invitationList = [NSMutableArray arrayWithArray:invites];
	[invitationTable reloadData];
	[self stopLoading];
	[self stopGettingMore:noMore];
}

- (void)stopGettingMore:(BOOL) noMore {
	[moreButton setBackgroundColor: [UIColor whiteColor]];
	[moreSpinner stopAnimating];
	NSString *title = noMore ? @"没有了。" : @"查看更多";
	[moreButton setTitle:title forState:UIControlStateNormal];
	isGettingMore = NO;
}

- (void)updateTableWith:(NSMutableDictionary *)dict {
	[invitationList insertObject:dict atIndex:0];
	[invitationTable reloadData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.invitationList = nil;
	self.invitationTable = nil;
	[self setRefreshHeaderView:nil];
	[self setRefreshLabel:nil];
	[self setRefreshArrow:nil];
	[self setMoreView:nil];
	[self setMoreButton:nil];
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
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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

#pragma mark -
#pragma mark Table View Delegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if (isLoading) return;
	isDragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (isLoading) return;
	isDragging = NO;
	if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
		[self startLoading];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (isLoading) {
		// Update the content inset, good for section headers
		if (scrollView.contentOffset.y > 0)
			self.invitationTable.contentInset = UIEdgeInsetsZero;
		else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
			self.invitationTable.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
	} else if (isDragging && scrollView.contentOffset.y < 0) {
		// Update the arrow direction and label
		[UIView animateWithDuration:0.25 animations:^{
			
			if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
				// User is scrolling above the header
				
				refreshLabel.text = kReleaseTextKey;
				[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
				
			} else {
				
				// User is scrolling somewhere within the header
				refreshLabel.text = kPullTextKey;
				[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
			}
			
		}];
	} else if (isDragging && scrollView.contentOffset.y > 0) {
			moreView.hidden = NO;
		if ((scrollView.contentOffset.y + scrollView.bounds.size.height) == scrollView.contentSize.height) {
		} else {
		}
	}
}

@end