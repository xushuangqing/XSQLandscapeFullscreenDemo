//
//  MovieView.m
//  XSQLandscapeFullscreenDemo
//
//  Created by 徐霜晴 on 17/1/23.
//  Copyright © 2017年 XSQ. All rights reserved.
//

#import "MovieView.h"

@implementation MovieView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.image = [UIImage imageNamed:@"movie"];
    }
    return self;
}

@end
