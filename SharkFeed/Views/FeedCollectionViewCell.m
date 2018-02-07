//
//  FeedCollectionViewCell.m
//  SharkFeed
//
//  Created by mike oh on 2018-02-06.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import "FeedCollectionViewCell.h"
#import "UIImage+Helpers.h"

@implementation FeedCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

- (void)setItem:(NSDictionary *)item {
    _item = item;
    __weak typeof(self) weakSelf = self;
    
    [UIImage loadFromURL:item[@"url_t"] completion:^(UIImage *image, NSString *urlString) {
        [weakSelf imageLoaded:image url:urlString];
    }];
}

- (void)imageLoaded:(UIImage *)image url:(NSString *)urlString {
    if ([self.item[@"url_t"] isEqualToString:urlString]) {
        self.imageView.image = image;
    }
}

@end
