//
//  Invitation.h
//  OO
//
//  Created by apple on 12-11-16.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CtquanInvitation : NSObject

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *endTime;

- (NSString *)endTimeString;
- (CtquanInvitation *)initWithDictionary: (NSDictionary *)dict;
@end
