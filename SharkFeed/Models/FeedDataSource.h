//
//  FeedDataSource.h
//  SharkFeed
//
//  Created by mike oh on 2018-02-05.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedViewController.h"

@protocol FeedDataSourceDelegate;

@interface FeedDataSource : NSObject

@property(nonatomic, readonly) NSArray *dataSource;
@property(nonatomic, weak) FeedViewController *delegate;

/**
 Set page No. to 1 which is reset.
 */
- (void)reset;

/**
 Load more image list by incresing page No.
 */
- (void)readMore;

@end

@protocol FeedDataSourceDelegate <NSObject>

/**
 Update collectionview UI this callback method.
 */
- (void)dataLoaded:(FeedViewController *)viewController;

@end
