//
//  EnterFullscreenTransition.m
//  XSQLandscapeFullscreenDemo
//
//  Created by 徐霜晴 on 17/1/23.
//  Copyright © 2017年 XSQ. All rights reserved.
//

#import "EnterFullscreenTransition.h"
#import "MovieView.h"

@interface EnterFullscreenTransition ()

@property (nonatomic, strong) UIView *movieView;

@end

@implementation EnterFullscreenTransition

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
    UIViewController *presentedViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *presentedView = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        presentedView = presentedViewController.view;
    }
    else {
        presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    
    CGRect smallMovieFrame = [[transitionContext containerView] convertRect:self.movieView.bounds fromView:self.movieView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        
        CGPoint centerAfterPresented = [transitionContext containerView].center;
        CGRect presentedViewFinalBounds = CGRectMake(0, 0, CGRectGetHeight([transitionContext containerView].bounds), CGRectGetWidth([transitionContext containerView].bounds));
        
        presentedView.bounds = self.movieView.bounds;
        presentedView.center = CGPointMake(CGRectGetMidX(smallMovieFrame), CGRectGetMidY(smallMovieFrame));
        [[transitionContext containerView] addSubview:presentedView];
        presentedView.transform = CGAffineTransformIdentity;
        
        /*
         * 将movieView放入presentedView中
         */
        self.movieView.frame = presentedView.bounds;
        [presentedView addSubview:self.movieView];
        
        if ([transitionContext isAnimated]) {
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                  delay:0.0
                                options:UIViewAnimationOptionLayoutSubviews
                             animations:^{
                                 /**
                                  *  iOS7中，屏幕旋转后，window.size不会变化，整个presentedView需要手工旋转
                                  */
                                 presentedView.bounds = presentedViewFinalBounds;
                                 presentedView.center = centerAfterPresented;
                                 presentedView.transform = CGAffineTransformMakeRotation(-M_PI_2);
                                 self.movieView.frame = presentedView.bounds;
                             }
                             completion:^(BOOL finished) {
                                 [transitionContext completeTransition:YES];
                             }];
        }
    }
    else {
        /*
         * 先将presentedView变成小屏的大小
         */
        presentedView.bounds = self.movieView.bounds;
        presentedView.transform = CGAffineTransformMakeRotation(M_PI_2);
        presentedView.center = CGPointMake(CGRectGetMidX(smallMovieFrame), CGRectGetMidY(smallMovieFrame));
        [[transitionContext containerView] addSubview:presentedView];
        
        /*
         * 将movieView放入presentedView中
         */
        self.movieView.frame = presentedView.bounds;
        [presentedView addSubview:self.movieView];
        
        /*
         * presentedView在动画中变为finalFrame
         */
        CGRect presentedViewFinalFrame = [transitionContext finalFrameForViewController:presentedViewController];
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0 options:UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             presentedView.transform = CGAffineTransformIdentity;
                             presentedView.frame = presentedViewFinalFrame;
                             self.movieView.frame = presentedView.bounds;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
}

@end
