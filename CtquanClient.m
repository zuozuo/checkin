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
		NSURL *url = [[NSURL alloc] initWithString:@"http://localhost:3000"];
		if (!client) {
			client = [[CtquanClient alloc] initWithBaseURL:url];
			[client registerHTTPOperationClass:[AFJSONRequestOperation class]];
			[client setDefaultHeader:@"Accept" value:@"application/json"];
		}
		return client;
	}
}

- (void)uplodaAvatarWith:(NSDictionary *)imageInfo FromController:(UIViewController *)controller {
	UIImage *image = [imageInfo objectForKey:UIImagePickerControllerEditedImage];
	NSURL *extURL = [imageInfo objectForKey:UIImagePickerControllerReferenceURL];
	NSString *ext = [[[extURL absoluteString] componentsSeparatedByString:@"&ext="] lastObject];
	NSData *imageData = UIImagePNGRepresentation(image);
	CtquanUser *currentUser = [CtquanUser current];
	NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"PUT"
																																 path:[NSString stringWithFormat:@"users/%@", currentUser.user_id]
																													 parameters:nil
																						constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
																							[formData appendPartWithFileData:imageData
																																					name:@"user[avatar]"
																																			fileName:[NSString stringWithFormat:@"avatar.%@", ext]
																																			mimeType:[NSString stringWithFormat:@"image/%@", ext]];
																						}];
		AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//			 NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//		}];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSError *error;
			NSDictionary *userInfo =[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
			currentUser.avatar = [userInfo objectForKey:@"avatar_file_name"];
			if ([controller respondsToSelector:@selector(uploadAvatarSuccess)])
				[controller performSelector:@selector(uploadAvatarSuccess)];
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"error: %@",  operation.responseString);
		}];
    [operation start];
}

@end

