//
//  Invitation.m
//  OO
//
//  Created by apple on 12-11-16.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanInvitation.h"

@implementation CtquanInvitation

@synthesize location, content, endTime;

- (NSString *)endTimeString {
	return [NSString stringWithFormat:@"%1.1f小时", [endTime timeIntervalSinceNow]/3600];
}

- (CtquanInvitation *)initWithDictionary: (NSDictionary *)dict {
	self = [super init];
	if (self) {
		location = [[CLLocation alloc]
								initWithLatitude:[[dict objectForKey:@"latitude"] doubleValue]
											 longitude:[[dict objectForKey:@"longitude"] doubleValue]];
		content = [[NSString alloc] initWithString:[dict objectForKey:@"content"]];
		endTime = [[NSDate alloc] initWithTimeIntervalSince1970:[[dict objectForKey:@"end_time"] intValue]];
	}
	return self;
}


@end