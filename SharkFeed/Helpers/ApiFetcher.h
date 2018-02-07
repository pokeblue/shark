//
//  ImageDownloader.h
//  SharkFeed
//
//  Created by mike oh on 2018-02-05.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApiFetcher : NSObject

/**
 Load image list associated with the search text.
 */
- (NSURLSessionTask *)imageListWithText:(NSString *)searchText withPage:(NSInteger)page success:(void (^)(NSDictionary *dic))success failure:(void (^)(NSError *error))failure;

/**
 Load a image details with id.
 */
- (NSURLSessionTask *)imageWithId:(NSString *)photoId success:(void (^)(NSDictionary *dic))success failure:(void (^)(NSError *error))failure;

@end
