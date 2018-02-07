//
//  UIImage+Helpers.h
//  SharkFeed
//
//  Created by mike oh on 2018-02-06.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helpers)

/**
 Load image from URL and callback to update image.
 */
+ (void)loadFromURL:(NSString*)urlString completion:(void (^)(UIImage *image, NSString *urlString))completion;

@end
