//
//  FullscreenViewController.m
//  XSQLandscapeFullscreenDemo
//
//  Created by 徐霜晴 on 17/1/23.
//  Copyright © 2017年 XSQ. All rights reserved.
//

#import "FullscreenViewController.h"

@interface FullscreenViewController ()

@end

@implementation FullscreenViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
