//
//  UIImage+Helpers.m
//  SharkFeed
//
//  Created by mike oh on 2018-02-06.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import "UIImage+Helpers.h"

@implementation UIImage (Helpers)

+ (void)loadFromURL:(NSString*)urlString completion:(void (^)(UIImage *image, NSString *urlString))completion {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image, urlString);
        });
    });
}

@end
