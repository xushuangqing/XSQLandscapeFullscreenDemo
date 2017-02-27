//
//  ExitFullscreenTransition.h
//  XSQLandscapeFullscreenDemo
//
//  Created by 徐霜晴 on 17/1/23.
//  Copyright © 2017年 XSQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MovieView;

@interface ExitFullscreenTransition : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithMovieView:(MovieView *)movieView;

@end
