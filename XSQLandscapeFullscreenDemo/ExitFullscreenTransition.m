//
//  ExitFullscreenTransition.m
//  XSQLandscapeFullscreenDemo
//
//  Created by 徐霜晴 on 17/1/23.
//  Copyright © 2017年 XSQ. All rights reserved.
//

#import "ExitFullscreenTransition.h"
#import "MovieView.h"

@interface ExitFullscreenTransition ()

@property (nonatomic, strong) MovieView *movieView;

@end

@implementation ExitFullscreenTransition

- (instancetype)initWithMovieView:(MovieView *)movieView {
    self = [super init];
    if (self) {
        _movieView = movieView;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *dismissingViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *dismissingView = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        dismissingView = dismissingViewController.view;
    }
    else {
        dismissingView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    }
    
    CGRect smallMovieFrame = [[transitionContext containerView] convertRect:self.movieView.movieViewFrame fromView:self.movieView.movieViewParentView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         dismissingView.transform = CGAffineTransformIdentity;
                         dismissingView.frame = smallMovieFrame;
                         self.movieView.frame = dismissingView.bounds;
                     }
                     completion:^(BOOL finished) {
                         self.movieView.frame = self.movieView.movieViewFrame;
                         [self.movieView.movieViewParentView addSubview:self.movieView];
                         [dismissingView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

@end
