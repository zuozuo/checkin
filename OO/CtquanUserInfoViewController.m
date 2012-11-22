//
//  CtquanUserInfoViewController.m
//  OO
//
//  Created by apple on 12-11-21.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanUserInfoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

#define kPhotoLibraryButtonIndex 0
#define kCameraButtonIndex 1

@interface CtquanUserInfoViewController ()
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;
@end

@implementation CtquanUserInfoViewController

@synthesize avatarView, nameCell, usernameCell;

- (void)viewDidLoad {
	[avatarView setImageWithURL:[[CtquanUser current] thumbAvatarURL]];
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	CtquanUser *currentUser = [CtquanUser current];
	nameCell.detailTextLabel.text = currentUser.name;
	usernameCell.detailTextLabel.text = currentUser.username;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}
//
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == kPhotoLibraryButtonIndex)
		[self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
	else if (buttonIndex == kCameraButtonIndex && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		[self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
	NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
	if ([UIImagePickerController isSourceTypeAvailable: sourceType] && [mediaTypes count] > 0) {
		NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.mediaTypes = mediaTypes;
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = sourceType;
		[self presentViewController:picker animated:YES completion:nil];
	} else {
		UIAlertView *alert = [[UIAlertView alloc]
													initWithTitle:@"Error accessing media"
													message:@"Device doesn’t support that media source."
													delegate:nil
													cancelButtonTitle:@"Drat!"
													otherButtonTitles:nil];
		[alert show]; }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0 && indexPath.section == 0) [self uploadAvatar];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0 && indexPath.section == 0) [self uploadAvatar];
}

- (void)uploadAvatar {
	NSString *camera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ? @"拍照" : nil;
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
																initWithTitle:@"选择头像"
																delegate:self
																cancelButtonTitle:@"取消"
																destructiveButtonTitle:@"相册"
																otherButtonTitles:camera,nil];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSString *lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
		[[CtquanClient sharedClient] uplodaAvatarWith:info FromController:self];
		UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
		avatarView.image = chosenImage;
	}
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidUnload {
	[self setNameCell:nil];
	[self setUsernameCell:nil];
	[super viewDidUnload];
}
@end
