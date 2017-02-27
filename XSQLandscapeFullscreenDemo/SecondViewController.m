//
//  SecondViewController.m
//  XSQLandscapeFullscreenDemo
//
//  Created by 徐霜晴 on 17/1/23.
//  Copyright © 2017年 XSQ. All rights reserved.
//

#import "SecondViewController.h"
#import "EnterFullscreenTransition.h"
#import "ExitFullscreenTransition.h"
#import "FullscreenViewController.h"
#import "MovieView.h"

@interface SecondViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) MovieView *movieView;
@property (nonatomic, strong) FullscreenViewController *fullscreenViewController;

@property (nonatomic, strong) UILabel *buggyLabel;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movieView = [[MovieView alloc] init];
    self.movieView.userInteractionEnabled = YES;
    self.movieView.frame = CGRectMake(0, 100, 320, 180);
    [self.view addSubview:self.movieView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.movieView addGestureRecognizer:tapGestureRecognizer];
    
    self.buggyLabel = [[UILabel alloc] init];
    self.buggyLabel.text = @"示例：通过读取window的长宽来布局会导致动画过程中布局异常";
    self.buggyLabel.numberOfLines = 0;
    self.buggyLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.buggyLabel];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat width = [UIApplication sharedApplication].keyWindow.bounds.size.width / 2.0;
    self.buggyLabel.frame = CGRectMake(0, 400, width, 200);
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
    
    self.movieView.movieViewFrame = self.movieView.frame;
    self.movieView.movieViewParentView = self.movieView.superview;
    
    FullscreenViewController *fullscreenViewController = [[FullscreenViewController alloc] init];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        fullscreenViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    else {
        fullscreenViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    fullscreenViewController.transitioningDelegate = self;
    fullscreenViewController.modalPresentationCapturesStatusBarAppearance = true;
    [self presentViewController:fullscreenViewController animated:YES completion:^{
        self.movieView.state = MovieViewStateFullscreen;
    }];
    self.fullscreenViewController = fullscreenViewController;
}

- (void)exitFullscreen {
    
    if (self.movieView.state != MovieViewStateFullscreen) {
        return;
    }
    
    self.movieView.state = MovieViewStateAnimating;
    [self.fullscreenViewController dismissViewControllerAnimated:YES completion:^{
        self.movieView.state = MovieViewStateSmall;
    }];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[EnterFullscreenTransition alloc] initWithMovieView:self.movieView];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[ExitFullscreenTransition alloc] initWithMovieView:self.movieView];
}


@end
