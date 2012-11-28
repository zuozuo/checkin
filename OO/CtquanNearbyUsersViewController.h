//
//  CtquanNearbyUsersViewController.h
//  OO
//
//  Created by apple on 12-11-15.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface CtquanNearbyUsersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *refreshHeaderView;

@property (strong, nonatomic) UILabel *refreshLabel;
@property (strong, nonatomic) UIImageView *refreshArrow;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL isDragging;

@property (strong, nonatomic) NSMutableArray *invitationList;
@property (strong, nonatomic) IBOutlet UITableView *invitationTable;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;

@property (strong, nonatomic) IBOutlet UIView *moreView;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (nonatomic, retain) UIActivityIndicatorView *moreSpinner;
@property (nonatomic) BOOL isGettingMore;

@property (nonatomic) NSInteger displayNumber;

- (void)refresh;
- (void)afterSignIn;
- (void)stopLoading;
- (void)startLoading;
- (NSNumber *)invitationsNumber;
- (void)updateTableWith:(NSMutableDictionary *)dict;
@end
