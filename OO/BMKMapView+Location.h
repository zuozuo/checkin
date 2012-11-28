//
//  BMKMapView+Location.h
//  OO
//
//  Created by apple on 12-11-28.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "BMKMapView.h"

@interface BMKMapView (Location)
+ (BMKMapView *)share;
- (void)getLocationInSeconds:(double)seconds begin:(void (^)())begin success:(void (^)())success failure:(void (^)())failure;
@end
