//
//  BMKMapView+Location.m
//  OO
//
//  Created by apple on 12-11-28.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "BMKMapView+Location.h"

@implementation BMKMapView (Location)

+ (BMKMapView *)share {
	static BMKMapView *view;
	@synchronized(self) {
		if (!view) view = [[BMKMapView alloc] init];
	}
	return view;
}

- (void)getLocationInSeconds:(double)seconds begin:(void (^)())begin success:(void (^)())success failure:(void (^)())failure {
	begin();
	sleep(3);
	for (double i=0.0; i<seconds; i++) {
		if (self.userLocation.location) break;
		[NSThread sleepForTimeInterval:1.0];
	}
	if (self.userLocation) {
		[CtquanUser current].location = self.userLocation.location;
		success();
	}
	else failure();
}

@end
