//
//  CtquanNearbyUsersViewController.h
//  OO
//
//  Created by apple on 12-11-15.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CtquanNearbyUsersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *invitationList;
@property (strong, nonatomic) IBOutlet UITableView *invitationTable;

- (void)afterSignIn;
	
@end
