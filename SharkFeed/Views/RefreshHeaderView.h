//
//  RefreshHeaderView.h
//  SharkFeed
//
//  Created by mike oh on 2018-02-06.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    PullRefreshPulling = 0,
    PullRefreshNormal,
    PullRefreshLoading,
    PullRefreshLoadingMore
} PullRefreshState;

@protocol RefreshHeaderDelegate;

@interface RefreshHeaderView : UIView

@property(nonatomic) PullRefreshState state;
@property(nonatomic, weak) id<RefreshHeaderDelegate> delegate;

/**
 State changes between Pulling and Normal when scrolling.
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/**
 Loading when conditions are complied.
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;

/**
 Reset RefreshView when loading is completed.
 */
- (void)scrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol RefreshHeaderDelegate <NSObject>
- (void)refreshTableHeaderDidTriggerRefresh:(RefreshHeaderView *)view top:(BOOL)top;
- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshHeaderView *)view;
@end
