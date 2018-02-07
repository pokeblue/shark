//
//  LightboxViewController.m
//  SharkFeed
//
//  Created by mike oh on 2018-02-06.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import "LightboxViewController.h"
#import "UIImage+Helpers.h"
#import "ViewControllerAnimatedTransition.h"
#import "ImageViewer.h"

@interface LightboxViewController ()

@property (weak, nonatomic) IBOutlet ImageViewer *imageViewer;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *openAppButton;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LightboxViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.preloadedImage) {
        self.imageViewer.image = self.preloadedImage;
    }
    
    if(self.item) {
        self.descriptionLabel.text = [self coalescingString:self.item[@"title"]];
        NSString *url = self.item[@"url_o"] ? self.item[@"url_o"] : self.item[@"url_l"];
        __weak typeof(self) weakSelf = self;
        [UIImage loadFromURL:url completion:^(UIImage *image, NSString *urlString) {
            weakSelf.imageViewer.image = image;
        }];
    }
}

#pragma mark private methods

- (NSString *)coalescingString:(NSString *)aString {
    if (aString) {
        return aString;
    }
    return @"";
}

- (void)loading:(BOOL)isLoading {
    self.loadingView.hidden = !isLoading;
    if (isLoading) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
}

- (void)loaded:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void (^)(NSString *))contextInfo {
    [self loading:NO];
}

#pragma mark - setters

- (void)setItem:(NSDictionary *)item {
    _item = item;
}

- (void)setPreloadedImage:(UIImage *)preloadedImage {
    _preloadedImage = preloadedImage;
}

#pragma mark actions

- (IBAction)closeClicked:(id)sender {
    //Unwind
}

- (IBAction)downloadClicked:(id)sender {
    if (self.imageViewer.image) {
        [self loading:YES];
        UIImageWriteToSavedPhotosAlbum(self.imageViewer.image, self, @selector(loaded: didFinishSavingWithError: contextInfo:), nil);
    }
}

- (IBAction)openAppClicked:(id)sender {
    //Note: The certificate warning may prevent you from seeing a image in the safari.
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.item[@"url_o"]]];
}

@end
