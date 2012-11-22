//
//  CtquanUser.h
//  OO
//
//  Created by apple on 12-11-14.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CtquanUser : NSObject <NSCoding, CLLocationManagerDelegate>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSNumber *user_id;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSNumber *signInStatus;
@property (strong, nonatomic) CLLocationManager *locationManager;

+ (CtquanUser *)current;
+ (NSString *)dataFilePath;
+ (CtquanUser *)performUnarchive;

- (BOOL)existsLocally;
- (void)signInLocation;
- (void)performArchive;
- (NSNumber *)latitude;
- (CtquanUser *)signIn;
- (NSNumber *)longitude;
- (NSURL *)thumbAvatarURL;
- (NSURL *)originalAvatarURL;
- (void)sendDistanceAndDuration;
- (CtquanUser *)signInFromController: (id)controller;
- (CtquanUser *)initWithDictionary:(NSDictionary *)dict;
- (double)distanceFromLocation: (CLLocation *)newLocation;
- (void)signUpFromController:(UIViewController *)controller;
- (NSString *)distanceStringFromLocation: (CLLocation *) newLocation;
- (void)getNearbyInvitationsFromController: (UIViewController *)controller;
- (void)updateWith:(NSDictionary *)params FromController:(UIViewController *)controller;
- (CtquanUser *)signInWith:(NSString *)email andPassword:(NSString *)password FromController:(id)controller;
- (void)sendInvitationWithContent: (NSString *)content andDuration: (NSNumber *)newDuration FromController: (UIViewController *)controller;

@end
