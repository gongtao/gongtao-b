//
//  BMToolBar.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMToolBar.h"

@implementation BMToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, 1.0)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"999999"];
        [self addSubview:lineView];
    }
    return self;
}

@end
