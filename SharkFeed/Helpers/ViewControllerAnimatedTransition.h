//
//  ViewControllerAnimatedTransition.h
//  SharkFeed
//
//  Created by mike oh on 2018-02-07.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerAnimatedTransition : NSObject<UIViewControllerAnimatedTransitioning>

/**
 Flag for presenting or dismissing.
 */
@property (nonatomic) BOOL reverse;

/**
 Starting animation position.
 */
@property (nonatomic, assign) CGRect frame;

@end
