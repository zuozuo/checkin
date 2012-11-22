//
//  CtquanClient.h
//  OO
//
//  Created by apple on 12-11-15.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "AFHTTPClient.h"

@interface CtquanClient : AFHTTPClient

+ (CtquanClient *)sharedClient;
- (void)uplodaAvatarWith:(NSDictionary *)imageInfo FromController:(UIViewController *)controller;
	
@end
