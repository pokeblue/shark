//
//  FeedCollectionViewCell.h
//  SharkFeed
//
//  Created by mike oh on 2018-02-06.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/**
 The item date to display.
 */
@property (nonatomic) NSDictionary *item;

@end
