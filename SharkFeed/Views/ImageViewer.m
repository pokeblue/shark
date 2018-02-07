//
//  ImageViewer.m
//  SharkFeed
//
//  Created by mike oh on 2018-02-07.
//  Copyright © 2018 mike oh. All rights reserved.
//

#import "ImageViewer.h"

@interface ImageViewer() <UIScrollViewDelegate> {
    CGFloat maxScale;
    CGFloat minScale;
}

@property(nonatomic) UIImageView* imageView;
@property(nonatomic) UIScrollView* scrollView;

@end

@implementation ImageViewer

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self=[super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if(self=[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.autoresizesSubviews = YES;
    
    maxScale = 1;
    minScale = 1;
    
    _scrollView = [UIScrollView.alloc initWithFrame:self.frame];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.autoresizesSubviews = YES;
    _scrollView.delegate=self;
    _scrollView.scrollEnabled = YES;
    [self addSubview:self.scrollView];
    
    _imageView = [UIImageView.alloc init];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - setter

- (void)setImage:(UIImage *)image {
    _image = image;
    if(_image) {
        self.imageView.image = _image;
        [self setNeedsLayout];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerImage:scrollView];
}

#pragma mark - views

- (void)centerImage:(UIScrollView *)scrollView {
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)updateViews {
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    CGFloat imageWidth = self.image.size.width;
    CGFloat imageHeight = self.image.size.height;
    
    CGFloat frameWidth=self.scrollView.frame.size.width;
    CGFloat frameHeight=self.scrollView.frame.size.height;
    
    if(imageWidth/imageHeight>=frameWidth/frameHeight) {
        minScale=frameHeight*screenScale/imageHeight;
        maxScale=imageHeight/frameHeight*screenScale;
    } else {
        minScale=frameWidth*screenScale/imageWidth;
        maxScale=imageWidth/frameWidth*screenScale;
    }
    if(maxScale<minScale) {
        maxScale=minScale;
    }
    
    self.scrollView.maximumZoomScale = MAX(maxScale,1.0f);
    
    CGFloat width=roundf(imageWidth*minScale / screenScale);
    CGFloat height=roundf(imageHeight*minScale / screenScale);
    
    self.imageView.frame = CGRectMake(0,0 , width , height);
    self.scrollView.contentSize = CGSizeMake(width,height);
    
    CGFloat imageY=0;
    CGFloat imageX=0;
    
    if(height>frameHeight) {
        CGFloat delta = height-frameHeight;
        imageY=delta/2.0f;
        minScale = 1.0 - delta/height;
    }
    if(width>frameWidth) {
        CGFloat delta = width-frameWidth;
        imageX=delta/2.0f;
        minScale = 1.0 - delta/width;
    }
    self.scrollView.minimumZoomScale= MIN(minScale,1.0f);
    self.scrollView.contentOffset=CGPointMake(imageX,imageY);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if(self.image) {
        [self updateViews];
    }
}

@end
