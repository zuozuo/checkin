//
//  Invitation.m
//  OO
//
//  Created by apple on 12-11-16.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanInvitation.h"

@implementation CtquanInvitation

@synthesize location, content, endTime, user;

- (NSString *)endTimeString {
	return [NSString stringWithFormat:@"%1.1f小时", [endTime timeIntervalSinceNow]/3600];
}

- (CtquanInvitation *)initWithDictionary: (NSDictionary *)dict {
	self = [super init];
	NSDictionary *invitation = [dict objectForKey:@"invitation"];
	if (self) {
		location = [[CLLocation alloc]
								initWithLatitude:[[invitation objectForKey:@"latitude"] doubleValue]
											 longitude:[[invitation objectForKey:@"longitude"] doubleValue]];
		content = [[NSString alloc] initWithString:[invitation objectForKey:@"content"]];
		endTime = [[NSDate alloc] initWithTimeIntervalSince1970:[[invitation objectForKey:@"end_time"] intValue]];
		user = [[CtquanUser alloc] initWithDictionary:[dict objectForKey:@"user"]];
	}
	return self;
}


@end