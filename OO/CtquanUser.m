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
#define kAvatarKey @"avatar_file_name"
#define kUserIdKey @"user_id"
#define kUsernameKey @"username"
#define kPasswordKey @"password"

#define kCurrentUserKey @"currentUser"

#define kSignInPathKey @"users/sign_in"

@implementation CtquanUser

@synthesize user_id, name, email, avatar,username, password, location, duration, distance, signInStatus, locationManager;

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

- (BOOL)existsLocally {
	return !(!email || !password);
}

- (CtquanUser *)signIn {
	return [self signInWith:email andPassword:password FromController:nil];
}

- (NSNumber *)latitude {
	return [NSNumber numberWithFloat:location.coordinate.latitude];
}

- (NSNumber *)longitude {
	return [NSNumber numberWithFloat:location.coordinate.longitude];
}

- (NSURL *)thumbAvatarURL {
	if ([avatar respondsToSelector:@selector(length)]) {
		return [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:3000/system/avatars//%@/thumb/%@?%d", user_id, avatar, [[NSNumber numberWithFloat:[NSDate timeIntervalSinceReferenceDate]] integerValue]]];
	} else {
		return [self defaultAvatarURL];
	}
}

- (NSURL *)originalAvatarURL {
	if ([avatar respondsToSelector:@selector(length)]) {
		return [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:3000/system/avatars//%@/original/%@?%d", user_id, avatar, [[NSNumber numberWithFloat:[NSDate timeIntervalSinceReferenceDate]] integerValue]]];
	} else {
		return [self defaultAvatarURL];
	}
}

- (NSURL *)defaultAvatarURL {
	return [[NSBundle mainBundle] URLForResource:@"add_avatar" withExtension:@"png"];
}


- (void)signInLocation {
	self.locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
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

- (void)signUpFromController:(id)controller {
	CtquanClient *client = [CtquanClient sharedClient];
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
													email, @"user[email]",
													username, @"user[username",
													password, @"user[password]",
													password,@"user[password_confirmation]",
													nil];
	[client postPath:@"users" parameters:params
					 success:^(AFHTTPRequestOperation *operation, id responseObject){
						 user_id = [responseObject objectForKey:@"id"];
						 [self performArchive];
						 if ([controller respondsToSelector:@selector(afterSignUp)])
							 [controller performSelector:@selector(afterSignUp)];
					 } failure:^(AFHTTPRequestOperation *operation, NSError *error){
						 NSLog(@"sign up failure");
					 }];
}

- (CtquanUser *)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		name = [dict objectForKey:kNameKey];
		email = [dict objectForKey:kEmailKey];
		avatar = [dict objectForKey:kAvatarKey];
		user_id = [dict objectForKey:@"id"];
		username = [dict objectForKey:kUsernameKey];
		password = [dict objectForKey:kPasswordKey];
	}
	return self;
}

- (CtquanUser *)signInFromController: (id)controller {
	return [self signInWith:email andPassword:password FromController:controller];
}

- (double)distanceFromLocation: (CLLocation *)newLocation {
	return [location distanceFromLocation:newLocation]/1000;
}

- (NSString *)distanceStringFromLocation: (CLLocation *)newLocation {
	return [NSString stringWithFormat:@"%1.2fkm", [self distanceFromLocation:newLocation]];
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

- (void)updateWith:(NSDictionary *)params FromController:(UIViewController *)controller {
	CtquanClient *client = [CtquanClient sharedClient];
	[client putPath:[NSString stringWithFormat:@"users/%@", user_id] parameters:params
					 success:^(AFHTTPRequestOperation *operation, id responseObject){
						 name = [responseObject objectForKey:@"name"];
						 username = [responseObject objectForKey:@"username"];
						 [self performArchive];
						 if ([controller respondsToSelector:@selector(afterUpdated)])
							 [controller performSelector:@selector(afterUpdated)];
					 } failure:^(AFHTTPRequestOperation *operation, NSError *error){
					 }];
}

- (CtquanUser *)signInWith:(NSString *)loginEmail andPassword:(NSString *)loginPassword FromController:(id)controller {
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
					avatar = [responseObject objectForKey:@"avatar_file_name"];
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
	return [NSString stringWithFormat:@"{\n"
					"          email => '%@', \n"
					"          user_id => '%@' \n"
					"          username => '%@', \n"
					"          name => '%@', \n"
					"          avatar => '%@', \n"
					"          password => '%@', \n"
					"          duration => '%@', \n"
					"          distance => '%@', \n"
					"          hasSignIn => %@ \n}",
					email, user_id, username, name, avatar, password, duration, distance, [signInStatus boolValue] ? @"YES" : @"NO"];
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
