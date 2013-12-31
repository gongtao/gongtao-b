//
//  BMSearchView.m
//  BananaNews
//
//  Created by 龚涛 on 12/31/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMSearchView.h"

@implementation BMSearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = Color_CellBg;
        self.layer.borderColor = Color_GayLine.CGColor;
        self.layer.borderWidth = 1.0;
    }
    return self;
}

@end
