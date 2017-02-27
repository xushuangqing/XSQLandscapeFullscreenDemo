//
//  FirstViewController.m
//  XSQLandscapeFullscreenDemo
//
//  Created by 徐霜晴 on 17/1/23.
//  Copyright © 2017年 XSQ. All rights reserved.
//

#import "FirstViewController.h"
#import "MovieView.h"


@interface FirstViewController ()

@property (nonatomic, strong) MovieView *movieView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movieView = [[MovieView alloc] init];
    self.movieView.userInteractionEnabled = YES;
    self.movieView.frame = CGRectMake(0, 100, 320, 180);
    [self.view addSubview:self.movieView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.movieView addGestureRecognizer:tapGestureRecognizer];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.movieView.state == MovieViewStateSmall) {
            [self enterFullscreen];
        }
        else if (self.movieView.state == MovieViewStateFullscreen) {
            [self exitFullscreen];
        }
    }
}

- (void)enterFullscreen {
    
    if (self.movieView.state != MovieViewStateSmall) {
        return;
    }
    
    self.movieView.state = MovieViewStateAnimating;
    
    /*
     * 记录进入全屏前的parentView和frame
     */
    self.movieView.movieViewParentView = self.movieView.superview;
    self.movieView.movieViewFrame = self.movieView.frame;
    
    /*
     * movieView移到window上
     */
    CGRect rectInWindow = [self.movieView convertRect:self.movieView.bounds toView:[UIApplication sharedApplication].keyWindow];
    [self.movieView removeFromSuperview];
    self.movieView.frame = rectInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:self.movieView];
    
    /*
     * 执行动画
     */
    [UIView animateWithDuration:0.5 animations:^{
        self.movieView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.movieView.bounds = CGRectMake(0, 0, CGRectGetHeight(self.movieView.superview.bounds), CGRectGetWidth(self.movieView.superview.bounds));
        self.movieView.center = CGPointMake(CGRectGetMidX(self.movieView.superview.bounds), CGRectGetMidY(self.movieView.superview.bounds));
    } completion:^(BOOL finished) {
        self.movieView.state = MovieViewStateFullscreen;
    }];
}

- (void)exitFullscreen {
    
    if (self.movieView.state != MovieViewStateFullscreen) {
        return;
    }
    
    self.movieView.state = MovieViewStateAnimating;
    
    CGRect frame = [self.movieView.movieViewParentView convertRect:self.movieView.movieViewFrame toView:[UIApplication sharedApplication].keyWindow];
    [UIView animateWithDuration:0.5 animations:^{
        self.movieView.transform = CGAffineTransformIdentity;
        self.movieView.frame = frame;
    } completion:^(BOOL finished) {
        /*
         * movieView回到小屏位置
         */
        [self.movieView removeFromSuperview];
        self.movieView.frame = self.movieView.movieViewFrame;
        [self.movieView.movieViewParentView addSubview:self.movieView];
        self.movieView.state = MovieViewStateSmall;
    }];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
