//
//  ViewControllerAnimatedTransition.m
//  SharkFeed
//
//  Created by mike oh on 2018-02-07.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import "ViewControllerAnimatedTransition.h"

static NSTimeInterval const ViewControllerAnimatedTransitionDuration = 0.15f;

@implementation ViewControllerAnimatedTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    CGPoint toCenter = toViewController.view.center;
    CGPoint cellCenter = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    if (!self.reverse) {
        [container addSubview:toViewController.view];
        toViewController.view.transform = CGAffineTransformMakeScale(0.3, 0.3);
        toViewController.view.alpha = 0.3;
        toViewController.view.center = cellCenter;
    }
    
    __weak typeof(self) weakSelf = self;
    
    void(^AnimationBlock)(void) = ^ {
        if (weakSelf.reverse) {
            fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
            fromViewController.view.alpha = 0;
            fromViewController.view.center = cellCenter;
        } else {
            toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
            toViewController.view.alpha = 1;
            toViewController.view.center = toCenter;
        }
    };
    
    [UIView animateWithDuration:1 delay:0.0f usingSpringWithDamping:50.0 initialSpringVelocity:4
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         AnimationBlock();
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                         if (weakSelf.reverse) {
                             [fromViewController.view removeFromSuperview];
                         }
                     }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return ViewControllerAnimatedTransitionDuration;
}

@end
