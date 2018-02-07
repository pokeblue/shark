//
//  FeedViewController.m
//  SharkFeed
//
//  Created by mike oh on 2018-02-05.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedDataSource.h"
#import "FeedCollectionViewCell.h"
#import "LightboxViewController.h"
#import "RefreshHeaderView.h"
#import "ViewControllerAnimatedTransition.h"

@interface FeedViewController () <UICollectionViewDataSource,UICollectionViewDelegate,FeedDataSourceDelegate,RefreshHeaderDelegate,UIViewControllerTransitioningDelegate> {
    BOOL isLoading;
    CGRect selectedCellFrameInSuperView;
    CGFloat refreshHeaderInsect;
}

@property(nonatomic) FeedDataSource *feedDataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet RefreshHeaderView *refreshViewHeader;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SharkFeed.png"]];
    selectedCellFrameInSuperView = CGRectZero;
    [self initRefreshHeader];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [super viewWillAppear:animated];
    [self HeaderViewOnTop:YES];
    refreshHeaderInsect = self.refreshViewHeader.frame.size.height;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self HeaderViewOnTop:YES];
}

- (void)initRefreshHeader {
    self.refreshViewHeader.delegate = self;
    [self.collectionView addSubview:self.refreshViewHeader];
}

#pragma mark private methods

- (void)HeaderViewOnTop:(BOOL)top {
    CGRect frame = self.refreshViewHeader.frame;

    frame.origin.y = top ? -frame.size.height : self.collectionView.contentSize.height;
    self.refreshViewHeader.frame = frame;
}

- (void)setSelectedCellFrame:(NSIndexPath *)indexPath {
    if (!indexPath) {
        selectedCellFrameInSuperView = CGRectZero;
        return;
    }
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    selectedCellFrameInSuperView = [self.collectionView convertRect:attributes.frame toView:[self.collectionView superview]];
}

#pragma mark - getters

- (FeedDataSource *)feedDataSource {
    if(!_feedDataSource) {
        _feedDataSource = [FeedDataSource.alloc init];
        _feedDataSource.delegate = self;
        [_feedDataSource reset];
    }
    return _feedDataSource;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[LightboxViewController class]]) {
        NSIndexPath *indexPath = self.collectionView.indexPathsForSelectedItems.firstObject;
        [self setSelectedCellFrame:indexPath];
        FeedCollectionViewCell *cell = sender;
        LightboxViewController *vc = segue.destinationViewController;
        vc.transitioningDelegate = self;
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.preloadedImage = cell.imageView.image;
        vc.item = cell.item;
    }
}

- (IBAction)unwindAction:(UIStoryboardSegue *)segue {

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.feedDataSource.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"FeedCell";
    
    FeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.item = self.feedDataSource.dataSource[indexPath.row];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - FeedDataSourceDelegate

- (void)dataLoaded:(FeedViewController *)viewController {
    isLoading = NO;
    [self.refreshViewHeader scrollViewDataSourceDidFinishedLoading:self.collectionView];
    [self.collectionView reloadData];
}

#pragma mark - RefreshHeaderDelegate

- (void)refreshTableHeaderDidTriggerRefresh:(RefreshHeaderView *)view top:(BOOL)isTop{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.collectionView.contentInset = UIEdgeInsetsMake(isTop ? refreshHeaderInsect : 0.0f, 0.0f, isTop ? 0.0f : refreshHeaderInsect, 0.0f);
    [UIView commitAnimations];
    
    isLoading = YES;
    if (isTop) {
        [self.feedDataSource reset];
    } else {
        [self.feedDataSource readMore];
    }
}

- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshHeaderView *)view {
    return isLoading;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.refreshViewHeader scrollViewDidScroll:scrollView];

    if (self.refreshViewHeader.state == PullRefreshLoading) {
        scrollView.contentInset = UIEdgeInsetsMake(refreshHeaderInsect, 0.0f, 0.0f, 0.0f);
    } else if (self.refreshViewHeader.state == PullRefreshLoadingMore) {
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, refreshHeaderInsect, 0.0f);
    } else if (scrollView.isDragging) {
        if (scrollView.contentInset.top != 0 || scrollView.contentInset.bottom != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }

        [self HeaderViewOnTop:scrollView.contentOffset.y<scrollView.contentSize.height/2];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.refreshViewHeader scrollViewDidEndDragging:scrollView];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark Transitioning Delegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    ViewControllerAnimatedTransition *transitioning = [ViewControllerAnimatedTransition new];
    transitioning.frame = selectedCellFrameInSuperView;
    return transitioning;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    ViewControllerAnimatedTransition *transitioning = [ViewControllerAnimatedTransition new];
    transitioning.reverse = YES;
    transitioning.frame = selectedCellFrameInSuperView;
    return transitioning;
}

@end
