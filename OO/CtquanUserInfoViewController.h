//
//  CtquanUserInfoViewController.h
//  OO
//
//  Created by apple on 12-11-21.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CtquanAvatarView.h"

@interface CtquanUserInfoViewController : UITableViewController
	<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet CtquanAvatarView *avatarView;
@property (strong, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *usernameCell;

@end
