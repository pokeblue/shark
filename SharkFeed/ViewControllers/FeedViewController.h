//
//  FeedViewController.h
//  SharkFeed
//
//  Created by mike oh on 2018-02-05.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController

///-----------------------------------------------------------------------------
/// @name Pull to Refresh
///-----------------------------------------------------------------------------

/**
 Enable Pull to Refresh.  The pull to refresh view is added as a subview to the tableView
 outside of its top bounds.
 */
@property (nonatomic) BOOL pullToRefreshEnabled;

/**
 The UIView to use with pull to refresh. May be overridden.
 */
//@property (nonatomic, strong) UTRefreshTableHeaderView* refreshView;

- (void)dataLoaded:(FeedViewController *)viewController;

@end
