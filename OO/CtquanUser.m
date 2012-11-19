//
//  CtquanUser.m
//  OO
//
//  Created by apple on 12-11-14.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanUser.h"
#import "AFJSONRequestOperation.h"

#define kNameKey @"name"
#define kEmailKey @"email"
#define kUserIdKey @"user_id"
#define kUsernameKey @"username"
#define kPasswordKey @"password"

#define kCurrentUserKey @"currentUser"

#define kSignInPathKey @"users/sign_in"

@implementation CtquanUser

@synthesize user_id, name, email, username, password, location, duration, distance, signInStatus, locationManager;

+ (CtquanUser *)current {
	static CtquanUser *currentUser;
	@synchronized(self) {
		if (!currentUser) {
			currentUser = [CtquanUser performUnarchive];
			if (!currentUser) {
				currentUser = [[CtquanUser alloc] init];
				currentUser.distance = [NSNumber numberWithFloat:1];
				currentUser.duration = [NSNumber numberWithFloat:0];
			}
		}
		return currentUser;
	}
}

+ (NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kCurrentUserKey];
}

+ (CtquanUser *)performUnarchive {
	NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[CtquanUser dataFilePath]];
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	CtquanUser *currentUser = [unarchiver decodeObjectForKey:kCurrentUserKey];
	return currentUser;
}

- (NSNumber *)latitude {
	return [NSNumber numberWithFloat:location.coordinate.latitude];
}

- (NSNumber *)longitude {
	return [NSNumber numberWithFloat:location.coordinate.longitude];
}

- (void)signInLocation {
	self.locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
}

- (CtquanUser *)signin {
	return [self signinWith:email andPassword:password fromController:nil];
}

- (CtquanUser *)signinFromController: (UIViewController *)controller {
	return [self signinWith:email andPassword:password fromController:controller];
}

- (BOOL)existsLocally {
	return !(!email || !password);
}

- (void)sendDistanceAndDuration {
	CtquanClient *client = [CtquanClient sharedClient];
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
													[NSNumber numberWithFloat:[distance floatValue]*2], @"user[distance]",
													[NSNumber numberWithFloat:[duration floatValue]*2], @"user[duration]",
													nil];
	[client putPath:[NSString stringWithFormat:@"users/%@", self.user_id] parameters:params
					 success:^(AFHTTPRequestOperation *operation, id responseObject){
					 } failure:^(AFHTTPRequestOperation *operation, NSError *error){
					 }];
	

}

- (void)getNearbyInvitationsFromController: (UIViewController *)controller {
	CtquanClient *client = [CtquanClient sharedClient];
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
													[NSNumber numberWithFloat:self.location.coordinate.latitude], @"latitude",
													[NSNumber numberWithFloat:self.location.coordinate.longitude], @"longitude",
													distance, @"distance",
													duration, @"duration",
													nil];
	[client getPath:@"invitations" parameters:params
					 success:^(AFHTTPRequestOperation *operation, id responseObject){
						 if ([controller respondsToSelector:@selector(invitationGetted:)])
							 [controller performSelector:@selector(invitationGetted:) withObject:responseObject];
					 } failure:^(AFHTTPRequestOperation *operation, NSError *error){
						 if ([controller respondsToSelector:@selector(invitationGetFailed)])
							 [controller performSelector:@selector(invitationGetFailed)];
					 }];
}


- (double)distanceFromLocation: (CLLocation *)newLocation {
	return [location distanceFromLocation:newLocation]/1000;
}

- (NSString *)distanceStringFromLocation: (CLLocation *)newLocation {
	return [NSString stringWithFormat:@"%1.2fkm", [self distanceFromLocation:newLocation]];
}

- (CtquanUser *)signinWith:(NSString *)loginEmail andPassword:(NSString *)loginPassword fromController:(id)controller {
	CtquanClient *client = [CtquanClient sharedClient];
	
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
													loginEmail, @"user[email]",
													loginPassword, @"user[password]", nil];
	[client postPath:kSignInPathKey parameters:params
			success:^(AFHTTPRequestOperation *operation, id responseObject){
				if ([[responseObject objectForKey:@"email"] isEqual:loginEmail]) {
					name = [responseObject objectForKey:@"name"];
					email = [responseObject objectForKey:@"email"];
					user_id = [responseObject objectForKey:@"id"];
					username = [responseObject objectForKey:@"username"];
					distance = [NSNumber numberWithFloat:[[responseObject objectForKey:@"distance"] floatValue]/2];
					duration = [NSNumber numberWithFloat:[[responseObject objectForKey:@"duration"] floatValue]/2];
					password = loginPassword;
					signInStatus= [NSNumber numberWithBool:YES];
					[self performArchive];
					
					if ([controller respondsToSelector:@selector(afterSignIn)])
						[controller performSelector:@selector(afterSignIn)];
				}
			} failure:^(AFHTTPRequestOperation *operation, NSError *error){
				if ([controller respondsToSelector:@selector(failedToSignIn)])
					[controller performSelector:@selector(failedToSignIn)];
				NSLog(@"Login Error!");
			}];
	return self;
}

- (void)sendInvitationWithContent:(NSString *)content andDuration:(NSNumber *)newDuration FromController:(UIViewController *)controller {
	CtquanClient *client = [CtquanClient sharedClient];
	NSString *path = [NSString stringWithFormat:@"users/%d/invitations/", [self.user_id integerValue]];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
																 content, @"invitation[content]",
																 [self latitude], @"invitation[latitude]",
																 [self longitude], @"invitation[longitude]",
																 newDuration, @"invitation[duration]",
																 nil];
	[client postPath:path parameters:params
																 success:^(AFHTTPRequestOperation *operation, id responseObject){
																 	 if ([controller respondsToSelector:@selector(afterSignIn)])
																		 [controller performSelector:@selector(afterSignIn)];
																 }
																 failure:^(AFHTTPRequestOperation *operation, NSError *error){
																 	 NSLog(@"failure");
																 }];
}

- (void)performArchive {
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:self forKey:kCurrentUserKey];
	[archiver finishEncoding];
	[data writeToFile:[CtquanUser dataFilePath] atomically:YES];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"User with property list:  \n{ "
					"email => '%@', "
					"user_id => '%@' "
					"username => '%@', "
					"name => '%@', "
					"password => '%@', "
					"duration => '%@', "
					"distance => '%@', "
					"hasSignIn => %@ }",
					email, user_id, username, name, password, duration, distance, [signInStatus boolValue] ? @"YES" : @"NO"];
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:name forKey:kNameKey];
	[aCoder encodeObject:email forKey:kEmailKey];
	[aCoder encodeObject:user_id forKey:kUserIdKey];
	[aCoder encodeObject:password forKey:kPasswordKey];
	[aCoder encodeObject:username forKey:kUsernameKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self == [super init]) {
		name = [aDecoder decodeObjectForKey:kNameKey];
		email = [aDecoder decodeObjectForKey:kEmailKey];
		user_id = [aDecoder decodeObjectForKey:kUserIdKey];
		password = [aDecoder decodeObjectForKey:kPasswordKey];
		username = [aDecoder decodeObjectForKey:kUsernameKey];
	}
	return self;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	location = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
	UIAlertView *alert = [[UIAlertView alloc]
												initWithTitle:@"Error getting Location"
												message:errorType
												delegate:nil
												cancelButtonTitle:@"Okay"
												otherButtonTitles:nil];
	[alert show];
}
@end
