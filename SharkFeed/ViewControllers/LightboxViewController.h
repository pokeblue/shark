//
//  LightboxViewController.h
//  SharkFeed
//
//  Created by mike oh on 2018-02-06.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightboxViewController : UIViewController

/**
 The item date to display.
 */
@property (nonatomic) NSDictionary* item;

/**
 A small image to display before a full image is downloaded.
 */
@property (nonatomic) UIImage* preloadedImage;

@end
