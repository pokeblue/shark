//
//  RefreshHeaderView.m
//  SharkFeed
//
//  Created by mike oh on 2018-02-06.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import "RefreshHeaderView.h"

@interface RefreshHeaderView () {
    CGFloat _threshold;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic) CGFloat threshold;

@end

@implementation RefreshHeaderView

- (void)setState:(PullRefreshState)aState{
    switch (aState) {
        case PullRefreshPulling:
            self.titleLabel.text = @"Release to refresh shark";
            break;
        case PullRefreshNormal:
            self.titleLabel.text = @"Pull down to refresh shark";
            break;
        case PullRefreshLoading:
        case PullRefreshLoadingMore:
            self.titleLabel.text = @"Loading...";
            break;
        default:
            break;
    }
    
    _state = aState;
}

- (BOOL)isLoading {
    BOOL loading = [self.delegate refreshTableHeaderDataSourceIsLoading:self];
    return loading;
}

- (CGFloat)threshold {
    if(_threshold == 0) {
        _threshold = self.frame.size.height;
    }
    return _threshold;
}

- (BOOL)isTopLoadable:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    return offsetY < -self.threshold;
}

- (BOOL)isBottomLoadable:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    return offsetY >= scrollView.contentSize.height -scrollView.frame.size.height + self.threshold;
}

#pragma mark ScrollView Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self isLoading] || self.state == PullRefreshLoading || self.state == PullRefreshLoadingMore) {
        return;
    }
    
    if (scrollView.isDragging) {
        CGFloat offsetY = scrollView.contentOffset.y;
        PullRefreshState aState = PullRefreshNormal;
        if (offsetY < 0) {
            if ([self isTopLoadable:scrollView]) {
                aState=PullRefreshPulling;
            }
        } else {
            if ([self isBottomLoadable:scrollView]) {
                aState=PullRefreshPulling;
            }
        }
        [self setState:aState];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    if ([self isLoading]) {
        return;
    }
    
    if ([self isTopLoadable:scrollView]) {
        [self.delegate refreshTableHeaderDidTriggerRefresh:self top:YES];
        [self setState:PullRefreshLoading];
    } else if ([self isBottomLoadable:scrollView]) {
        [self.delegate refreshTableHeaderDidTriggerRefresh:self top:NO];
        [self setState:PullRefreshLoadingMore];
    }
}

- (void)scrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsZero];
    [UIView commitAnimations];
    
    [self setState:PullRefreshNormal];
}

@end
