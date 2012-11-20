//
//  CtquanClient.m
//  OO
//
//  Created by apple on 12-11-15.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanClient.h"
#import "AFJSONRequestOperation.h"

@implementation CtquanClient

+ (CtquanClient *)sharedClient {
	static CtquanClient *client;
	@synchronized(self) {
		NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.1.150:3000"];
		if (!client) {
			client = [[CtquanClient alloc] initWithBaseURL:url];
			[client registerHTTPOperationClass:[AFJSONRequestOperation class]];
			[client setDefaultHeader:@"Accept" value:@"application/json"];
		}
		return client;
	}
}

@end
