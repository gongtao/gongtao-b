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
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(7.0, (frame.size.height-18.0)/2, frame.size.width-32.0, 18.0)];
        _textField.font = [UIFont systemFontOfSize:14.0];
        _textField.placeholder = @"搜索更多";
        _textField.textColor = Color_SideFont;
        _textField.returnKeyType = UIReturnKeySearch;
        [self addSubview:_textField];
        
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-25.0, (frame.size.height-25.0)/2, 25.0, 25.0)];
        [_searchButton setImage:[UIImage imageNamed:@"搜索.png"] forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"搜索按下.png"] forState:UIControlStateHighlighted];
        [self addSubview:_searchButton];
    }
    return self;
}

@end
